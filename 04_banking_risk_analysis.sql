CREATE TABLE loan_portfolio (
    emp_title VARCHAR(255),
    emp_length NUMERIC,
    state VARCHAR(10),
    homeownership VARCHAR(50),
    annual_income NUMERIC(12,2),
    verified_income VARCHAR(50),
    debt_to_income NUMERIC(8,2),
    delinq_2y NUMERIC,
    months_since_last_delinq NUMERIC,
    earliest_credit_line NUMERIC,
    inquiries_last_12m NUMERIC,
    total_credit_lines NUMERIC,
    open_credit_lines NUMERIC,
    total_credit_limit NUMERIC(12,2),
    total_credit_utilized NUMERIC(12,2),
    num_historical_failed_to_pay NUMERIC,
    public_record_bankrupt NUMERIC,
    loan_purpose VARCHAR(100),
    application_type VARCHAR(50),
    loan_amount NUMERIC(12,2),
    term NUMERIC,
    interest_rate NUMERIC(5,2),
    installment NUMERIC(10,2),
    grade VARCHAR(5),
    sub_grade VARCHAR(10),
    issue_month VARCHAR(20),
    loan_status VARCHAR(100),
    balance NUMERIC(12,2),
    paid_total NUMERIC(12,2),
    paid_principal NUMERIC(12,2),
    paid_interest NUMERIC(12,2),
    paid_late_fees NUMERIC(12,2),
    is_default INT
);

SELECT COUNT(*) FROM loan_portfolio;

-- Step 1 :- Overall Portfolio Health (Executive Summary KPIs)

SELECT 
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed_amount,
    ROUND(AVG(interest_rate), 2) AS avg_interest_rate_pct,
    ROUND(AVG(debt_to_income), 2) AS avg_dti_ratio,
    SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END) AS total_default_loans,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM loan_portfolio;

-- Step 2 :- Risk Grade Breakdown (Credit Risk Segmentation)

SELECT 
    grade,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan_amount,
    ROUND(AVG(interest_rate), 2) AS avg_interest_rate,
    SUM(CASE WHEN is_default = 1 THEN loan_amount ELSE 0 END) AS defaulted_amount,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM loan_portfolio
GROUP BY grade
ORDER BY grade;

-- Step 3 :- Default Rate by Loan Purpose (Risk Factor Identification)

SELECT 
    loan_purpose,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END) AS default_count,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM loan_portfolio
GROUP BY loan_purpose
ORDER BY default_rate_pct DESC;

-- Step 4 :- Home Ownership & Borrower Stability Analysis
SELECT 
    homeownership,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(annual_income), 2) AS avg_annual_income,
    ROUND(AVG(debt_to_income), 2) AS avg_dti,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM loan_portfolio
GROUP BY homeownership
ORDER BY default_rate_pct DESC;

-- Step 5 :- High-Risk Delinquency Bucket Analysis

SELECT 
    CASE 
        WHEN delinq_2y = 0 THEN 'No Past Delinquency'
        WHEN delinq_2y BETWEEN 1 AND 2 THEN '1-2 Delinquencies'
        ELSE '3+ High Delinquencies'
    END AS delinquency_risk_category,
    COUNT(*) AS total_borrowers,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM loan_portfolio
GROUP BY 1
ORDER BY default_rate_pct DESC;

-- Step 6 :- Risk Class Window Functions & Cumulative Disbursal

SELECT 
    grade,
    sub_grade,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS sub_grade_amount,
    SUM(SUM(loan_amount)) OVER (
        PARTITION BY grade 
        ORDER BY sub_grade
    ) AS cumulative_grade_amount,
    ROUND(
        (SUM(loan_amount) / SUM(SUM(loan_amount)) OVER (PARTITION BY grade)) * 100, 
        2
    ) AS pct_share_of_grade
FROM loan_portfolio
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;

-- Step 7 :- Debt-to-Income (DTI) Quartile Segmentation

WITH dti_buckets AS (
    SELECT 
        loan_amount,
        debt_to_income,
        is_default,
        NTILE(4) OVER (ORDER BY debt_to_income ASC) AS dti_quartile
    FROM loan_portfolio
)
SELECT 
    CASE 
        WHEN dti_quartile = 1 THEN 'Q1 - Low DTI (Lowest Risk)'
        WHEN dti_quartile = 2 THEN 'Q2 - Moderate DTI'
        WHEN dti_quartile = 3 THEN 'Q3 - High DTI'
        ELSE 'Q4 - Extreme DTI (Highest Risk)'
    END AS dti_risk_segment,
    COUNT(*) AS total_borrowers,
    ROUND(MIN(debt_to_income), 2) AS min_dti,
    ROUND(MAX(debt_to_income), 2) AS max_dti,
    SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END) AS default_count,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM dti_buckets
GROUP BY dti_quartile
ORDER BY dti_quartile;

-- Step 8 :- High-Risk Borrower Profiling

WITH high_interest_loans AS (
    SELECT * 
    FROM loan_portfolio
    WHERE interest_rate > 15.0
),
delinquent_borrowers AS (
    SELECT * 
    FROM high_interest_loans
    WHERE delinq_2y > 0 OR public_record_bankrupt > 0
)
SELECT 
    grade,
    homeownership,
    COUNT(*) AS high_risk_borrower_count,
    SUM(loan_amount) AS total_at_risk_capital,
    ROUND(AVG(interest_rate), 2) AS avg_risk_interest,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM delinquent_borrowers
GROUP BY grade, homeownership
ORDER BY total_at_risk_capital DESC;

-- Step 9 :- Income Percentile Rank vs Default Risk

WITH income_ranked AS (
    SELECT 
        annual_income,
        loan_amount,
        is_default,
        PERCENT_RANK() OVER (ORDER BY annual_income ASC) AS income_percentile
    FROM loan_portfolio
)
SELECT 
    CASE 
        WHEN income_percentile <= 0.20 THEN 'Bottom 20% (Lowest Income)'
        WHEN income_percentile <= 0.80 THEN 'Middle 60% (Moderate Income)'
        ELSE 'Top 20% (Highest Income)'
    END AS income_tier,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(annual_income), 2) AS avg_tier_income,
    ROUND((SUM(CASE WHEN is_default = 1 THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)) * 100, 2) AS default_rate_pct
FROM income_ranked
GROUP BY 1
ORDER BY avg_tier_income ASC;

-- Step 10 :- Loss Exposure & Recovery Rate Analysis

WITH financial_summary AS (
    SELECT 
        grade,
        SUM(loan_amount) AS total_disbursed,
        SUM(paid_total) AS total_recovered,
        SUM(balance) AS outstanding_balance,
        SUM(CASE WHEN is_default = 1 THEN loan_amount - paid_total ELSE 0 END) AS estimated_loss
    FROM loan_portfolio
    GROUP BY grade
)
SELECT 
    grade,
    total_disbursed,
    total_recovered,
    outstanding_balance,
    estimated_loss,
    ROUND((total_recovered / total_disbursed) * 100, 2) AS recovery_rate_pct,
    -- Grade ranking by loss severity
    DENSE_RANK() OVER (ORDER BY estimated_loss DESC) AS loss_rank
FROM financial_summary
ORDER BY loss_rank;


