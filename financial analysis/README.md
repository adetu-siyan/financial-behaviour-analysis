
# Personal Finance Intelligence: A SQL & Python Analysis of 12 Months of Nigerian Bank Transactions

A solo end-to-end data analysis project examining 12 months of real Moniepoint transaction data to uncover spending behaviour, savings consistency, and income vs. outflow patterns — using SQL as the primary analysis engine and Python for visualisation, anomaly detection, and predictive modelling.

## Project Summary

Most personal finance tools give you charts without explanation. This project goes underneath — using structured query logic to ask precise financial questions and return honest, data-backed answers. It also introduces predictive modelling to forecast future cashflow and statistical anomaly detection to flag unusual spending spikes.

The dataset covers 2,572 transactions spanning April 2025 to April 2026, exported directly from a personal Moniepoint account. All analysis was performed on raw, uncleaned bank data — including handling Moniepoint's export format quirks, stripping irrelevant columns, and building a categorisation engine from transaction reference prefixes.


## Business Questions Answered

### 💸 Spending & Income Behaviour
* How much did I spend each month, and how did that compare to my income?
* Which days of the week drain my account the most?
* What are my top spending days and what triggered them?
* How does my spending trend look over a rolling 3-month window?
* Which months did I spend above my own yearly average?

### 📈 Financial Health & Savings
* Which months did I save and which months did I run a deficit?
* Which quarter was my strongest and weakest financially?
* How much did I pay in bank charges and VAT across the year?
* What does my transaction categorisation reveal about where my money actually goes?

### 🤖 Advanced Analysis (Python)
* **Anomaly Detection:** Which daily spending days were statistical outliers?
* **Forecasting:** What are the predicted spending, income, and savings margin for April 2026?



## Technical Stack

| Tool | Purpose |
| :--- | :--- |
| **Python (Pandas)** | Data cleaning, transformation, and statistical analysis |
| **MySQL (Workbench)** | Primary analysis engine — structured queries & aggregations |
| **SQLAlchemy** | Python-to-MySQL database connection |
| **Matplotlib** | Data visualisation layer |
| **Scikit-learn** | Model evaluation (MAE calculation) |
| **Statsmodels (ARIMA)** | Time-series forecasting |
| **Jupyter Notebook** | Documentation, execution, and presentation |


## Dataset

* **Source:** Personal Moniepoint bank statement export (Excel)
* **Period:** April 2025 — April 2026
* **Rows:** 2,572 transactions
* **Columns:** 16 (Date, Transaction Ref, Settlement Debit, Settlement Credit, Balance Before, Balance After, Charge, Narration, and more)
* **Note:** Raw data is not included in this repository for privacy reasons. The schema, query logic, and aggregated outputs are fully public.



## Data Cleaning (Python)

```python
df = pd.read_excel("Moniepoint extended statement.xlsx")
df = df.dropna(subset=['Date'])
df = df.drop(["Unnamed: 4", "Unnamed: 5", "RRN"], axis=1)
df = df.drop(["Terminal ID", "Unnamed: 9", "Unnamed: 12", "Reversal Status"], axis=1)
```

**Key decisions:**
* Dropped ghost rows using `dropna(subset=['Date'])` — a common Moniepoint export artefact.
* Removed irrelevant columns including `Reversal Status` (all null) and unnamed Excel overflow columns.
* Retained 16 clean columns covering all analytically useful fields.
* Standardised date formats and handled missing `NaN` values in transaction references.



## SQL Queries — Analytical Breakdown

| # | Question | Key SQL Concept |
| :--- | :--- | :--- |
| Q1 | Monthly credits, debits and savings margin | `GROUP BY`, `SUM`, multi-column aggregation |
| Q2 | Top 5 highest spending days with full detail | `ORDER BY DESC`, `LIMIT` |
| Q3 | Top 5 highest credit days with full detail | `ORDER BY DESC`, `LIMIT` |
| Q4 | Total bank charges and VAT paid across the year | Subqueries, `LIKE` pattern matching |
| Q5 | Spending by day of the week | `DAYNAME()`, `DAYOFWEEK()`, `GROUP BY` |
| Q6 | Transaction categorisation breakdown | `CASE WHEN` with prefix pattern matching |
| Q7 | Months above yearly average spending | Nested subquery in `HAVING` |
| Q13 | Monthly spending vs 3-month rolling average | CTE + `AVG() OVER` with `ROWS BETWEEN` |



## Transaction Categorisation Engine (Q6)

A `CASE WHEN` engine categorises every transaction by parsing the `Transaction Reference` prefix:

| Prefix | Category | Direction |
| :--- | :--- | :--- |
| `ATP%` | Airtime purchase | Debit |
| `DTP%` | Data purchase | Debit |
| `TRF%` | Transfer out | Debit |
| `MIT\|HYD%` | Transfer received | Credit |
| `MIT\|HBP%` + debit | Electronic levy | Debit |
| `MIT\|HBP%` + credit | Transfer received | Credit |
| `USSD_CHARGE%` | USSD service charge | Debit |
| `CB_CSH%` | Cashback | Credit |
| `SAV%` | Savings | Debit |
| *Everything else* | Other | — |


## 🤖 Machine Learning & Statistical Analysis

### Anomaly Detection
Using a statistical threshold of `Mean + 2*Standard Deviation`, the model identifies days with abnormal spending spikes.
* **Mean Daily Spending:** ₦6,222.28
* **Standard Deviation:** ₦10,429.69
* **Anomaly Threshold:** ₦27,081.66
* **Result:** 7 anomalous days detected (e.g., ₦142,340 on July 13, 2025).

### ARIMA Forecasting
An `ARIMA(2,1,1)` model was trained on the 12-month monthly aggregates to forecast the next period.
* **Model Evaluation:** MAE ~₦70k for income/spending, ~₦4.8k for margin.
* **April 2026 Forecast:**
  * 📉 Predicted Spending: **₦185,375.55**
  * 📈 Predicted Income: **₦184,487.40**
  * ⚠️ Predicted Margin: **-₦1,353.83** (Projected slight deficit)



## Key Findings

1. **Transfer Out Dominance:** Transfers (`TRF`) account for **85.6%** of total debits — the account is primarily used for sending money rather than direct consumption spending.
2. **Peak Spending Month:** July 2025 was the peak spending month, significantly above the 3-month rolling average — driven by a few high-value transfer days.
3. **Strongest Savings Month:** October 2025 recorded the highest positive savings margin.
4. **Hidden Costs:** Over **₦81,000+** paid in bank charges and VAT across the year — a recurring cost that compounds silently.
5. **Sunday Spending Spike:** Sundays are consistently the highest spending day, behaviorally aligned with leisure and end-of-week social obligations.
6. **Anomalous Days:** 7 days exceeded the ₦27k threshold, with the highest being ₦142,340 in July.
7. **Forecast Warning:** ARIMA predicts a slight deficit of **-₦1,353** for April 2026, indicating income will slightly lag behind projected spending.



## 🚀 Fintech Product Implications

Every finding is framed around actionable product features:

* **Sunday Spending Spike** → Optimal window for a Saturday night savings nudge before the typical outflow day.
* **Rolling Average Trend** → Basis for dynamic savings targets that adjust monthly rather than using a fixed annual average.
* **₦81,000 in Charges** → Friction point that a smarter account product could reduce through charge alerts or charge-free transfer routing.
* **Transfer-Out Dominance** → Signals the account owner is a net sender, suggesting value in peer-to-peer flow analysis, scheduled transfers, or "send-to-save" features.
* **Forecasted Deficit** → Real-time cashflow warnings that prompt users to adjust spending or boost income mid-month.



## Visualisations

* Monthly credits vs debits with savings margin line (dual-axis chart)
* Top 5 highest spending days (bar chart)
* Spending by day of the week (bar chart)
* Monthly spending vs 3-month rolling average (dual line chart)
* Anomaly detection scatter plot (highlighting outliers above threshold)
* ARIMA model forecast plots (Actual vs Predicted for Spending, Income, and Margin)



## Repository Structure

├── financial_analysis.ipynb   # Full notebook: cleaning, SQL connection, queries, visualisations, ML modelling
├── README.md                  # Project documentation (this file)



## About

Built by **Adetu Siyanbola** — third-year Computer Science student at Osun State University, Campus Director at Afrique AI Lab, and data science practitioner focused on Nigerian fintech.

* **LinkedIn:** [linkedin.com/in/adetu-siyanbola](#)
* **X (Twitter):** [@AdetuMD](https://x.com/AdetuMD)
* **Substack:** [siyanadetu.substack.com](https://siyanadetu.substack.com)