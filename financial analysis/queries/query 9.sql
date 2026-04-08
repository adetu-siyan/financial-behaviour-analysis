-- in this query we are to get the month over month spending change, to do
-- this i introduced CTEs using the WITH tag, within it an inner query to 
-- get the total spendings by the month and as well as create my columns 
-- afterwards i proceeded to use LAG to retrieve the spending of the previous
-- month, then a subtraction to get the monthly change

WITH monthly AS (
    SELECT 
        MONTHNAME(date) AS month_name,
        YEAR(date) AS year_number,
        MONTH(date) AS month_number,
        SUM(`Settlement Debit (NGN)`) AS monthly_spending
    FROM transactions
    GROUP BY MONTHNAME(date), YEAR(date), MONTH(date)
)
SELECT 
    month_name,
    year_number,
    monthly_spending,
    LAG(monthly_spending) OVER (ORDER BY year_number, month_number) AS previous_month,
    monthly_spending - LAG(monthly_spending) OVER (ORDER BY year_number, month_number) AS monthly_change
FROM monthly;