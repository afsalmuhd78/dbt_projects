with raw_payments as (
    select * from {{ source('olist_raw', 'ORDER_PAYMENTS') }}
)

select
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value

from raw_payments