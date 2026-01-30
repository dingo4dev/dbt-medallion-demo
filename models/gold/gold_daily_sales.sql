{{
    config(
        materialized='table',
        tags=['gold', 'sales-analytics']
    )
}}

-- Gold layer: Daily sales metrics
SELECT
    order_date,
    COUNT(DISTINCT customer_id) as unique_customers,
    COUNT(order_id) as total_orders,
    COUNT(CASE WHEN is_completed THEN 1 END) as completed_orders,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_orders,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled_orders,
    SUM(CASE WHEN is_completed THEN order_amount ELSE 0 END) as daily_revenue,
    AVG(CASE WHEN is_completed THEN order_amount END) as avg_order_value,
    MIN(CASE WHEN is_completed THEN order_amount END) as min_order_value,
    MAX(CASE WHEN is_completed THEN order_amount END) as max_order_value
FROM {{ ref('silver_orders') }}
GROUP BY order_date
ORDER BY order_date
