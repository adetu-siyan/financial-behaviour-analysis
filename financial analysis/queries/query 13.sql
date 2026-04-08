-- Q13-Monthly spending vs 3-month rolling average
-- CTE + window function: was each month above or below my rolling trend?
-- this is an important context of understanding for Anomalous Detection

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
    AVG(monthly_spending) OVER (
        ORDER BY year_number, month_number 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3month_avg,
    CASE 
        WHEN monthly_spending > AVG(monthly_spending) OVER (
            ORDER BY year_number, month_number 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) THEN 'Above Average'
        ELSE 'Below Average'
    END AS spending_trend
FROM monthly
ORDER BY year_number, month_number;