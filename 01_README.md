# Banking & Risk Analysis

## Project Overview
This project analyzes retail loan portfolio data to evaluate credit risk exposure, loan performance, default drivers, and portfolio profitability. 
The project follows an end-to-end Data Analytics workflow using Python for data cleaning & EDA, PostgreSQL for business query analysis, and Power BI for data modeling and executive dashboard visualization.

## Business Problem
The financial institution wants to understand:
* Overall portfolio default rate and total loss exposure
* Which credit grades and sub-grades carry the highest risk of default
* Which loan purposes drive elevated credit defaults
* How loan term and interest rates impact risk and profitability
* How default rates trend over time across issuing months
* How risk varies across geographical states and homeownership categories

## Business Objectives
* Inspect, clean, and validate raw loan portfolio data for quality assurance.
* Perform SQL analysis to uncover key risk drivers, monthly default patterns, and financial KPIs.
* Calculate core KPIs including Total Disbursed, Total Loans, Default Rate %, Total Loss Exposure, and Average DTI.
* Identify high-risk credit grades, sub-grades, and specific loan purposes.
* Analyze homeownership types in relation to credit grades to pinpoint concentrated risk.
* Track monthly default trends over time for vintage analysis.
* Build an interactive 3-page Power BI dashboard for executive decision-making.

## Dataset
* **Rows:** 10,000
* **Columns:** 24
* **Period:** Jan 2018 – Mar 2018
* **Data Type:** Banking & Credit Risk Transactions
* **Key Fields:** `issue_month`, `loan_amount`, `paid_total`, `is_default`, `grade`, `sub_grade`, `loan_purpose`, `homeownership`, `interest_rate`, `debt_to_income`, `balance`, `state`

## Tools & Technologies
| Tool | Purpose |
| :--- | :--- |
| **Python (Pandas, NumPy)** | Data cleaning, data type validation, missing value handling, and exploratory data analysis (EDA) |
| **PostgreSQL** | Relational database analysis, KPI querying, grouping, window functions, and MoM tracking |
| **Power BI Desktop** | Data modeling, DAX measure creation, UI layout design, and dashboard development |
| **DAX (Data Analysis Expressions)** | Custom KPIs (`DIVIDE`, `COUNTROWS`), conditional aggregation, and date parsing/sorting logic |
| **GitHub** | Project documentation and portfolio showcase |

## Project Workflow

    Raw Dataset
         ↓
    Python Data Cleaning & EDA
         ↓
    PostgreSQL Analysis & Business Queries
         ↓
    Power BI Data Modeling & DAX Measures
         ↓
    Interactive 3-Page Power BI Dashboard
         ↓
    Business Insights & Risk Mitigation Recommendations

## Python Analysis
Python was used for:
* Data inspection and shape validation (10,000 rows × 24 columns)
* Missing value imputation and null check verification
* Data type conversion (converting text-based dates into standard ISO formats)
* Detecting outliers in `loan_amount`, `interest_rate`, and `debt_to_income`
* Exploratory Data Analysis (EDA) on default correlation across loan attributes

**Python File:**
`"03_Banking & Risk Analytics\03_data_cleaning.ipynb"`

## SQL Analysis
PostgreSQL was used for:
* Table schema creation and data loading validation
* Calculating global business KPIs (Total Disbursed, Total Default Loss, Overall Default Rate %)
* Monthly default rate tracking using `GROUP BY` and date ordering
* Cross-tab aggregation for Grade vs. Homeownership default distribution
* Identifying top loss-making loan purposes using analytical queries

**SQL File:**
`"03_Banking & Risk Analytics\04_banking_risk_analysis.sql"`

## Power BI Dashboard
The Power BI report contains three dedicated pages:

### 1. Executive Portfolio Overview
Provides a macro-level overview of portfolio health:
* Total Disbursed Amount
* Total Active Loans
* Baseline Default Rate %
* Average Interest Rate
* Default Rate by State
* Total Disbursed by Sub-Grade, Homeownership, and Loan Purpose

### 2. Credit Risk & Loss Analytics
Focuses on identifying specific risk drivers and loss exposure:
* Default Loans and Total Loss Exposure
* Average Debt-to-Income (DTI)
* Default Rate % by Credit Grade
* Default Rate % by Loan Purpose
* Default Rate Trend by Issue Month
* Cross-Matrix Analysis: Homeownership vs. Credit Grade Default Rates

### 3. Portfolio & Vintage Analytics
Focuses on vintage performance and financial metrics:
* Average Loan Balance, Annual Income, and Total Inquiries
* Total Disbursed and Default Rate % by Month
* Annual Income vs. Loan Balance scatter analysis by Grade
* Multi-level Matrix: Grade breakdown of Loans, Disbursed Volume, Default Rate %, and Loss Exposure

**Power BI File:**
`"03_Banking & Risk Analytics\05_Banking_Risk_Analytics_Dashboard.pbix"`


## Key KPIs
| KPI | Overall Result |
| :--- | :--- |
| **Total Disbursed** | $163.62M |
| **Total Loans** | 10,000 |
| **Default Loans** | 73 |
| **Default Rate %** | 0.07% |
| **Total Loss Exposure** | $1.33M |
| **Average Interest Rate** | 12.43% |
| **Average DTI** | 19.30 |
| **Average Balance** | $144.59M |
| **Annual Income (Portfolio Total)** | $792.22M |

## Key Business Insights

### Credit Grade Performance
* **Grade D** exhibits the highest default rate at **0.14%**, generating **$394.50K** in loss exposure across 1,446 loans.
* **Grade A** represents the largest loan volume (2,459 loans; $37.87M disbursed) with a lower default rate of **0.08%**.
* **Grades B and C** show low default rates of **0.07%** and **0.04%**, respectively.

### Loan Purpose Performance
* **`house`** loans represent the highest risk category with a **0.66%** default rate.
* **`home_improvement`** is the second highest risk driver at **0.29%** default rate.
* **`debt_consolidation`** accounts for the largest volume ($91M disbursed) with a low default rate of **0.04%**.

### Homeownership & Matrix Risk Analysis
* Within **Renters**, Grade D borrowers show a default rate of **0.31%**.
* Borrowers with **Own** homes in Grade B exhibit a default rate of **0.24%**.
* Borrowers with a **Mortgage** in Grade A have a default rate of **0.16%**.

### Monthly Vintage Trends
* Default rates peaked in **Jan 2018 at 0.15%** ($55M disbursed volume).
* Default rates stabilized in **Feb 2018 (0.03%)** and **Mar 2018 (0.03%)**.

## Business Recommendations
* **Tighten Underwriting for High-Risk Categories:** Apply stricter credit scoring and lower loan caps for `house` and `home_improvement` loan applications.
* **Monitor Grade D Exposures:** Implement targeted early-intervention strategies for Grade D borrowers, specifically those residing in rented properties.
* **Risk-Based Pricing Adjustments:** Adjust interest rates dynamically for higher-risk purposes to compensate for higher expected loss exposure ($1.33M total).
* **Capitalize on Low-Risk Drivers:** Maintain growth in `debt_consolidation` and `credit_card` loans, which show low default rates (0.04%) and high disbursement volumes.

## Project Structure

    Banking-and-Risk-Analytics-Dashboard/
    │
    ├── README.md
    │
    ├── data/
    │   └── public_loan_portfolio.csv
    │
    ├── python/
    │   └── Banking_Risk_Python_Analysis.ipynb
    │
    ├── sql/
    │   └── Banking_Risk_SQL_Analysis.sql
    │
    ├── powerbi/
    │   └── Banking_and_Risk_Analytics.pbix
    │
    └── screenshots/
        ├── executive-portfolio-overview.png
        ├── credit-risk-loss-analytics.png
        └── portfolio-vintage-analytics.png

## Dashboard Preview

### Executive Portfolio Overview
![Executive Portfolio Overview](screenshots/executive-portfolio-overview.png)

### Credit Risk & Loss Analytics
![Credit Risk & Loss Analytics](screenshots/credit-risk-loss-analytics.png)

### Portfolio & Vintage Analytics
![Portfolio & Vintage Analytics](screenshots/portfolio-vintage-analytics.png)
