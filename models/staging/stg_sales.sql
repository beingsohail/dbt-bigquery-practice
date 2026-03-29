select 
    store_id,
    product_id,
    quantity,
    DATE(sale_date) AS sale_date,
    CAST(promo_flag AS BOOL) AS is_promo
from `my-dbt-practice.raw.sales_raw`