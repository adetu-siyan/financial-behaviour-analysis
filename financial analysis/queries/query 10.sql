-- Q10- TO Calculate my daily cumulative balance from transactions

select `Balance After (NGN)` AS closing_balance
from transactions
where `Date` like '2026-04-01%'
order by `Date` desc
limit 1;