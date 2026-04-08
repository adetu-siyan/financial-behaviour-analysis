-- Q7 To identify month spendings above my year on month average
SELECT MONTHNAME(date), SUM(`Settlement Debit (NGN)`) AS monthly_spending
FROM transactions
GROUP BY MONTHNAME(date)
HAVING monthly_spending > (
    SELECT AVG(monthly_total) 
    FROM (
        SELECT SUM(`Settlement Debit (NGN)`) AS monthly_total
        FROM transactions
        GROUP BY MONTHNAME(date)
    ) AS monthly_totals
);