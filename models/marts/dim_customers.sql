{{ config(materialized='table') }}

with customer_metrics as (
    select * from {{ ref('int_customer_metrics') }}
)

select
    -- Customer Identity
    customer_unique_id,
    
    -- Geography
    city,
    state,
    
    -- Lifetime Metrics
    total_orders,
    lifetime_value,
    average_order_value

from customer_metrics