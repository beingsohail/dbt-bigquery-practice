
with prd_score as (
    select 
        pra.sku,
        pra.prd_health_score as score,
        ssc.supplier_name
    from 
        {{ ref('product_risk_assesment') }} pra
    left join 
        {{ ref('stg_supply_chain') }} ssc
    on pra.sku = ssc.sku
),

final as (
    select
        supplier_name,
        count(distinct sku) as total_products,
        round(avg(score), 3) as avg_prd_health_socre
    from prd_score
    group by 1
    order by 1
)

select * from final