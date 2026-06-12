with
    customers as (
        select *
        from {{ ref('stg_jaffle_shop_customers') }}
    ),

    orders as (
        select *
        from {{ ref('stg_jaffle_shop_orders') }}
    ),

    customer_orders as (
        select
            o.customer_id,
            count(customer_id) as total_orders,
            min(date(o.order_date)) as first_order_date,
            max(date(o.order_date)) as most_recent_order_date
        from orders o
        group by 1
    ),

    final as (
        select
            c.customer_id,
            c.first_name,
            c.last_name,
            coalesce(co.total_orders, 0) as total_orders,
            co.first_order_date,
            co.most_recent_order_date
        from customers c
        left join customer_orders co on c.customer_id = co.customer_id
        order by 1
    )

select *
from final
