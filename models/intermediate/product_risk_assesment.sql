WITH product_type_benchmark AS (
    SELECT
        product_type,
        AVG(manufacture_lead_time) AS avg_manufacture_lead_time,
        AVG(manufacture_cost) AS avg_manufacture_cost,
        AVG(defect_rate) AS avg_defect_rate
    FROM
        {{ ref('stg_supply_chain') }}
    GROUP BY
        1
),

sku_factors as (
    select
        sku,
        product_type,
        manufacture_lead_time,
        manufacture_cost,
        defect_rate
    from {{ ref('stg_supply_chain') }}
),

health_score AS (
    SELECT
        phs.sku,
        phs.product_type,
        GREATEST(
            0,
            100 - CASE
                WHEN manufacture_lead_time > avg_manufacture_lead_time THEN 10
                ELSE 0
            END - CASE
                WHEN manufacture_cost > avg_manufacture_cost THEN 10
                ELSE 0
            END - CASE
                WHEN inspection_result = 'fail' THEN 10
                ELSE 0
            END - CASE
                WHEN defect_rate > avg_defect_rate THEN 10
                ELSE 0
            END
        ) AS prd_health_score
    FROM
        {{ ref('stg_supply_chain') }}
        phs
        LEFT JOIN product_type_benchmark ptb
        ON phs.product_type = ptb.product_type
),

-- Here I can add risk reason CTE

risk_category as (

    select
        sf.sku,
        sf.product_type,

        coalesce(
            array_to_string(
                array(
                    select reason
                    from unnest([
                        if(
                            sf.manufacture_lead_time > ptb.avg_manufacture_lead_time,
                            'High Manufacturing Lead Time',
                            null
                        ),

                        if(
                            sf.manufacture_cost > ptb.avg_manufacture_cost,
                            'High Manufacturing Cost',
                            null
                        ),

                        if(
                            inspection_result = 'fail',
                            'Failed Inspection',
                            null
                        ),

                        if(
                            sf.defect_rate > ptb.avg_defect_rate,
                            'High Defect Rate',
                            null
                        )
                    ]) reason
                    where reason is not null
                ),
                ', '
            ),
            'No Major Risk'
        ) as risk_reason

    from sku_factors sf
    left join product_type_benchmark ptb
        on sf.product_type = ptb.product_type
    left join {{ ref('stg_supply_chain') }} ssc
        on sf.sku = ssc.sku
),

final as (
    select
        hs.sku,
        hs.product_type,
        sf.manufacture_lead_time,
        sf.manufacture_cost,
        sf.defect_rate,
        hs.prd_health_score,
        rc.risk_reason
    from health_score hs 
    left join sku_factors sf 
    on hs.sku = sf.sku
    left join risk_category rc 
    on hs.sku = rc.sku
    ORDER BY
        hs.sku
)

SELECT
    *
FROM
    final
