with final as (
    select
        `Product type` as product_type,
        SKU as sku,
        Price as price,
        Availability as availability,
        `Number of products sold` as total_sold_products,
        `Revenue generated` as revenue,
        `Customer demographics` as customer_demographics,
        `Stock levels` as stock_lvl,
        `Lead times` as lead_times,
        `Order quantities` as order_qty,
        `Shipping times` as shipping_time,
        `Shipping carriers` as shipping_carrier,
        `Shipping costs` as shipping_cost,
        `Supplier name` as supplier_name,
        Location as location,
        `Lead time` as lead_time,
        `Production volumes` as production_volume,
        `Manufacturing lead time` as manufacture_lead_time,
        `Manufacturing costs` as manufacture_cost,
        `Inspection results` as inspection_result,
        `Defect rates` as defect_rate,
        `Transportation modes` as transport_mode,
        Routes as route,
        Costs as cost
    from {{ source('supply_chain', 'supply_chain_dbt_raw') }}
)

select * from final