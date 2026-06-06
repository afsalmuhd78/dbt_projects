{{ config(materialized='table') }}

with products as (
    select * from {{ ref('int_products_enriched') }}
)

select
    product_id,
    category_name_en as product_category,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

from products