
with shipping_analysis as (
    select 
        shipping_carrier,
        count(distinct sku) as total_products_shipped,
        round(avg(shipping_time), 3) as avg_shipping_time,
        round(avg(shipping_cost), 3) as avg_shipping_cost,
        round(avg(defect_rate), 3) as avg_defect_rate
    from {{ ref('stg_supply_chain') }}
    group by 1
)


select * from shipping_analysis