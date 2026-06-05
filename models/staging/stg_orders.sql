with raw_orders as (
    select * from {{ source('olist_raw', 'ORDERS')}}
)
select
    -- Primary & Foreign Keys
    order_id,
    customer_id,
    
    -- Status
    order_status,
    
    -- Timestamps
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date

from raw_orders