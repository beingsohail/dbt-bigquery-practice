with source as (
    select *
    from `dbt-tutorial.stripe.payment`
),

renamed as (
    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status,
        amount,
        created as payment_date,
        _batched_at
    from source 
)

select * from renamed