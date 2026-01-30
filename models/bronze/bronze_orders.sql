{{
    config(
        materialized='view',
        tags=['bronze', 'orders']
    )
}}

-- Bronze layer: Raw order data with basic metadata
SELECT
    order_id,
    customer_id,
    order_date,
    order_amount,
    status,
    CURRENT_TIMESTAMP as _loaded_at,
    '{{ invocation_id }}' as _batch_id
FROM {{ ref('raw_orders') }}
