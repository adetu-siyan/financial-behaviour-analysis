-- Q5: daily spending total
-- Shows the sum of all money coming into my account for each month
-- DAYNAME() extracts the day name from the date column
-- SUM() adds up all debits within each monthly group
-- GROUP BY collapses all transactions in the same month into one row
-- ORDER BY to put it in order, DAYOFWEEK() is the criteria for ordering


SELECT DAYNAME(date) AS day_name, 
		SUM(`Settlement Debit (NGN)`) AS total_spending
FROM transactions
GROUP BY DAYNAME(date), DAYOFWEEK(date)
ORDER BY DAYOFWEEK(date)
