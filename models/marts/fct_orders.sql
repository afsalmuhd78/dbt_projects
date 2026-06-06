{{ config(materialized='table') }}

with orders as (
    select * from {{ ref('stg_orders') }}
),

logistics as (
    select * from {{ ref('int_orders_logistics') }}
),

payments as (
    select * from {{ ref('stg_order_payments') }}
),

-- Calculate the total revenue per order
order_totals as (
    select
        order_id,
        sum(payment_value) as total_revenue
    from payments
    group by 1
)

select 
    o.order_id,

    -- Foreign Keys (Connects to dim_customers)
    o.customer_id,

    -- Order Details
    o.order_status,
    o.order_purchase_timestamp as purchase_date,

    -- Logistics Performance (from our intermediate model)
    l.days_to_deliver,
    l.delay_variance_days,
    l.is_delayed,

    -- Financials (Using coalesce to ensure no nulls if an order had $0 payments)
    coalesce(t.total_revenue, 0) as total_revenue

from orders o
left join logistics l on o.order_id = l.order_id
left join order_totals t on o.order_id = t.order_id
