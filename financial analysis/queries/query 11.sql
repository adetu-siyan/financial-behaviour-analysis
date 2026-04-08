-- Q11 - in this query we are to rank Rank months by total debit
-- Which month was my worst financially — ranked 1 to 12?
-- to do this we first introduce a CTE then an outer query introducing
--  the rank() keyword

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
    RANK() OVER (ORDER BY monthly_spending DESC) AS Spending_Rank
FROM monthly;