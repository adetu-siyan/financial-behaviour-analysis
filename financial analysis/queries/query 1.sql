-- Q1: Monthly credit total
-- Shows the sum of all money coming into my account for each month
-- MONTHNAME() extracts the month name from the date column
-- SUM() adds up all credits within each monthly group
-- GROUP BY collapses all transactions in the same month into one row

use financial_analysis;

SELECT MONTHNAME(date),
    SUM(`Settlement Credit (NGN)`) AS total_credits,
    SUM(`Settlement Debit (NGN)`) AS total_debits,
    SUM(`Settlement Credit (NGN)`) - SUM(`Settlement Debit (NGN)`) AS margin
FROM transactions
GROUP BY MONTHNAME(date);
