with raw_products as (
    select * from {{ source('olist_raw', 'PRODUCTS') }}
)

select
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

from raw_products