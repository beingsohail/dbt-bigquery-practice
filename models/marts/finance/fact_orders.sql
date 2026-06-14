with orders as (
    select 
        *
    from {{ ref('stg_jaffle_shop_orders') }}
),

payment as (
    select *
    from {{ ref('stg_stripe_payments') }}
),

orders_payment as (
    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as total_amount
    from payment
    group by 1
),

final as (
    select 
        o.order_id,
        o.customer_id,
        o.order_date,
        coalesce(op.total_amount, 0) as amount
    from orders o
    left join orders_payment op using(order_id)
)

select * from final