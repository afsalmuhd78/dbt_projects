with products as (
    select * from {{ ref('stg_products') }}
),

translations as (
    select * from {{ ref('stg_category_translations') }}
)


select
    p.product_id,
    p.product_category_name as category_name_pt,

    -- If there is no English translation, default to 'Unknown'
    coalesce(t.category_name_en, 'Unknown') as category_name_en,

    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

from products p
left join translations t on p.product_category_name = t.category_name_pt