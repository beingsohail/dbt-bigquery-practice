with product_performance as (
    select 
        product_type,
        sku
        revencue,
        total_sold_products,
        stock_lvl,
        defect_rate
    from {{ ref('stg_supply_chain') }}
    order by product_type, sku
)

select * from product_performance