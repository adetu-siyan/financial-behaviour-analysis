-- query 6- categorising transfers based on their reference Prefixes

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'ATP%' 
LIMIT 10;
-- ATP fell on the debit side - most likely airtime top-up purchase

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'TRF%' 
LIMIT 10;
-- TRF fell on the debit side- most likely transfer out of account

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'MIT|HYD%' 
LIMIT 10;
-- MIT|HYD fell on the credit side, most likely inter bank transfer

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'MIT|HBP%'
LIMIT 10; 
-- MIT|HBP fell on debit as 50 after credit of N10000 most likely electronic charges

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'USSD_CHARGE%' ;
-- USSD_CHARGE fell on debit, these are charges after ussd

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'DTP%' 
LIMIT 10; 
-- most of it on the debit side- most likely data purchase, the ones on credits are reversals

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'CB_CSH%';
-- CB_CSH_OUT are all on the credit sides- cashbacks

SELECT `Transaction Ref`, `Narration`, `Settlement Debit (NGN)`, `Settlement Credit (NGN)`
FROM transactions
WHERE `Transaction Ref` LIKE 'SAV%';

SELECT `Transaction Ref`, `Settlement Credit (NGN)`, `Settlement Debit (NGN)`,`source`, Narration, Beneficiary
FROM transactions
WHERE `Transaction Ref` LIKE 'MIT|HBP%'
LIMIT 20;

-- SAV falls on debit side, most likely savings 

-- a safe conclusion is that TRF -transfer out
-- MIT|HYD for gifts and allowances
-- MIT|HBP and USSD_CHARGES for electronic levy/tax
-- DTP and ATP for data and Airtime transfer
-- CB_CSH_OUT for cashback withdrawal
-- SAV for savings


WITH categorised AS (
    SELECT 
    `Transaction Ref`,
    `Settlement Debit (NGN)`,
    `Settlement Credit (NGN)`,
CASE 
    WHEN `Transaction Ref` LIKE 'ATP%' THEN 'Airtime'
    WHEN `Transaction Ref` LIKE 'DTP%' THEN 'Data'
    WHEN `Transaction Ref` LIKE 'TRF%' THEN 'Transfers OUT'
    WHEN `Transaction Ref` LIKE 'MIT|HYD%' AND `Settlement Credit (NGN)` > 100 THEN 'Transfer IN'
    WHEN `Transaction Ref` LIKE '0000%' THEN 'Transfer IN'
WHEN `Transaction Ref` LIKE 'MIT|HBP%' AND `Settlement Debit (NGN)` > 0 THEN 'Electronic Levy'
WHEN `Transaction Ref` LIKE 'MIT|HBP%' AND `Settlement Credit (NGN)` > 0 THEN 'Transfer IN'
    WHEN `Transaction Ref` LIKE 'USSD_CHARGE%' THEN 'USSD charges'
	WHEN `Transaction Ref` LIKE 'CB_CSH%' THEN 'CashBacks'
	WHEN `Transaction Ref` LIKE 'SAV%' THEN 'Savings'
    else 'other'
END AS category
FROM transactions
)

SELECT category, 
       COUNT(*) AS transaction_count,
       SUM(`Settlement Debit (NGN)`) AS total_debit,
       SUM(`Settlement Credit (NGN)`) AS total_credit
FROM categorised
GROUP BY category
ORDER BY total_debit DESC;


