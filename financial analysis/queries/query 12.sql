-- Q12- to calculate Quarterly net position (using a CTE)
-- i Grouped months into Q1–Q4 — which quarter was strongest and weakest?
WITH quarterly AS (
    SELECT 
       quarter(date) AS quarter_name,
        YEAR(date) AS year_number,
        SUM(`Settlement Debit (NGN)`)- SUM(`Settlement Credit (NGN)`) AS monthly_spending
    FROM transactions
    GROUP BY quarter(date), YEAR(date)
)
SELECT 
    quarter_name,
    year_number,
    monthly_spending
FROM quarterly
ORDER BY year_number,quarter_name DESC;