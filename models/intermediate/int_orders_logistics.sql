with orders as (
    select * from {{ ref('stg_orders') }}
)
select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date,

    datediff('day', order_purchase_timestamp, order_delivered_customer_date) as days_to_deliver,
    datediff('day', order_estimated_delivery_date, order_delivered_carrier_date) as delay_variance_days,

    case
        when order_delivered_carrier_date > order_estimated_delivery_date then true
        else false
    end as is_delayed

from orders
where order_status = 'delivered'