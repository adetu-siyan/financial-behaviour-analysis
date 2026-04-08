-- for anomaly detection

SELECT date(`date`) AS day_date,
       SUM(`Settlement Debit (NGN)`) AS total_spending
FROM transactions
GROUP BY date(`date`)
ORDER BY day_date;