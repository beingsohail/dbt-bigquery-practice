with sp_performance as (
    select 
        supplier_name,
        total_products as total_products,
        avg_defect_rate
    from {{ ref('supplier_performance') }}
),

sp_prd_report as (
    select
        supplier_name,
        avg_prd_health_socre
    from {{ ref('supplier_product_report') }}
),

final as (
    SELECT
        sp.supplier_name,
        sp.total_products,
        sp.avg_defect_rate,
        spr.avg_prd_health_socre,
        CASE
            when avg_defect_rate < 2 and avg_prd_health_socre > 85 then 'Low'
            when avg_defect_rate < 2.5 and avg_prd_health_socre > 85 then 'Medium'
            else 'High' 
        end as supplier_risk_category
    from sp_performance sp
    left join sp_prd_report spr 
    on sp.supplier_name = spr.supplier_name
    order by 1
)

select * from final