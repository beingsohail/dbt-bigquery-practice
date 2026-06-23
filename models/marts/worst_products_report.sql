
with products as (
    select
        sku,
        product_type,
        prd_health_score,
        manufacture_lead_time,
        manufacture_cost,
        defect_rate,
        risk_reason,
        rank() over(
            order by 
                prd_health_score asc, 
                defect_rate desc,
                manufacture_lead_time desc, 
                manufacture_cost desc
            ) as rnk
    from {{ ref('product_risk_assesment') }}
),

supplier as (
    select
        sku,
        supplier_name
    from {{ ref('stg_supply_chain') }}
),

final as (
    select
        p.rnk as rank,
        p.sku,
        p.product_type,
        s.supplier_name,
        p.prd_health_score,
        p.risk_reason,
        p.defect_rate,
        p.manufacture_lead_time,
        p.manufacture_cost
    from products p 
    left join supplier s 
    on p.sku = s.sku
    where p.rnk < 11
)

select * from final