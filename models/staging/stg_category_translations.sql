with raw_translations as (
    select * from {{ source('olist_raw', 'CATEGORY_TRANSLATIONS') }}
)

select
    product_category_name as category_name_pt,
    product_category_name_english as category_name_en

from raw_translations