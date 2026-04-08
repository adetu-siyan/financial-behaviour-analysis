-- Q4:Total bank charges paid in the year
 -- show the total amount of charges paid
-- select sum sum(Settlement debit (NGN)) aggregate the total debits
-- from transactions- table name
-- where narration like `%VAT%` or %USSD_CHARGES% specifies the type of debit alerts to add
-- subqueries were introduce to properly catch the tax across the transaction datasets
  
  SELECT 
    (SELECT SUM(`Charge (NGN)`) FROM transactions) AS total_bank_charges,
    (SELECT SUM(`Settlement Debit (NGN)`) 
    FROM transactions 
    WHERE narration LIKE '%VAT%'OR narration LIKE '%fee%' OR `Transaction ref` like '%USSD_CHARGE%') AS total_VAT;