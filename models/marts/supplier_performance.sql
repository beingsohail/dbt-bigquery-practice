with supplier_performance as (
    select
        supplier_name,
        count(distinct sku) as total_products,
        round(avg(lead_time), 3) as avg_lead_time,
        round(avg(manufacture_cost), 3) as avg_manufacturing_cost,
        round(avg(defect_rate), 3) as avg_defect_rate
    from {{ ref("stg_supply_chain") }}
    group by 1
)

select * from supplier_performance