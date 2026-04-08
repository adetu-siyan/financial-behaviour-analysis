-- Q2: Top 5 highest credit days
 -- Shows the 5 transactions where the most money entering my account
 -- SELECT * retrieves full transaction detail for context
 -- ORDER BY DESC sorts from highest credit to lowest
 -- LIMIT 5 returns only the top 5 rows

SELECT *
 FROM transactions 
ORDER BY `Settlement Credit (NGN)` DESC 
LIMIT 5;