with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_order_payments') }}
),

-- 1. Aggregate payments to the order level (since one order can have multiple payments)
order_totals as (
    select
        order_id,
        sum(payment_value) as total_order_value
    from payments
    group by 1
),

-- 2. Join customers to their orders and order values
customer_order_history as (
    select
        c.customer_id,
        c.customer_unique_id,
        c.city,
        c.state,
        o.order_id,
        t.total_order_value
    from customers c
    left join orders o on c.customer_id = o.customer_id
    left join order_totals t on o.order_id = t.order_id
)

-- 3. Final aggregation to the unique customer level
select
    customer_unique_id,
    city,
    state,
    count(distinct order_id) as total_orders,
    sum(total_order_value) as lifetime_value,
    round(avg(total_order_value), 3) as average_order_value

from customer_order_history
group by 1, 2, 3