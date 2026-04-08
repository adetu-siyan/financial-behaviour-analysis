-- Q8 to calculate the highest individual debit
select *
from transactions
order by `settlement Debit (NGN)` Desc
limit 10;