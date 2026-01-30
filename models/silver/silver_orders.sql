{{
    config(
        materialized='view',
        tags=['silver', 'orders']
    )
}}

-- Silver layer: Cleaned and validated order data
SELECT
    order_id,
    customer_id,
    CAST(order_date AS DATE) as order_date,
    ROUND(CAST(order_amount AS DECIMAL(10,2)), 2) as order_amount,
    LOWER(TRIM(status)) as status,
    CASE
        WHEN status = 'completed' THEN TRUE
        ELSE FALSE
    END as is_completed,
    _loaded_at,
    _batch_id
FROM {{ ref('bronze_orders') }}
WHERE
    order_id IS NOT NULL
    AND customer_id IS NOT NULL
    AND order_amount > 0
