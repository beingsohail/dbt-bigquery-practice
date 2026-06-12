select 
    o.id as order_id,
    user_id as customer_id,
    amount
from `dbt-tutorial.jaffle_shop.orders` o
left join {{ ref('stg_stripe_payments') }} p on o.id = p.orderid