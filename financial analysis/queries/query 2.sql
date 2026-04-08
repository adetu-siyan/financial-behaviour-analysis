-- Q2: Top 5 highest spending days
-- Shows the 5 transactions where the most money left my account
-- SELECT * retrieves full transaction detail for context
-- ORDER BY DESC sorts from highest debit to lowest
-- LIMIT 5 returns only the top 5 rows

use financial_analysis;

SELECT * 
FROM transactions 
ORDER BY `Settlement Debit (NGN)` DESC
limit 5;