-- Store wise sales summary
select 
    store_id,
    sum(quantity) as total_sales,
    sum(case when is_promo then quantity else 0 end) as promo_sales
from {{ref('stg_sales')}}
group by store_id