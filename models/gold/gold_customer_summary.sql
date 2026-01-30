{{
    config(
        materialized='table',
        tags=['gold', 'customer-analytics']
    )
}}

-- Gold layer: Customer analytics and metrics
WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.email,
        c.country,
        c.signup_date,
        COUNT(o.order_id) as total_orders,
        COUNT(CASE WHEN o.is_completed THEN 1 END) as completed_orders,
        SUM(CASE WHEN o.is_completed THEN o.order_amount ELSE 0 END) as total_revenue,
        AVG(CASE WHEN o.is_completed THEN o.order_amount END) as avg_order_value,
        MIN(o.order_date) as first_order_date,
        MAX(o.order_date) as last_order_date
    FROM {{ ref('silver_customers') }} c
    LEFT JOIN {{ ref('silver_orders') }} o
        ON c.customer_id = o.customer_id
    GROUP BY 1, 2, 3, 4, 5
)

SELECT
    *,
    CASE
        WHEN total_orders = 0 THEN 'No Orders'
        WHEN total_orders = 1 THEN 'One-Time Buyer'
        WHEN total_orders <= 5 THEN 'Regular Customer'
        ELSE 'VIP Customer'
    END as customer_segment,
    CASE
        WHEN last_order_date IS NULL THEN NULL
        ELSE CURRENT_DATE - last_order_date
    END as days_since_last_order,
    ROUND(total_revenue / NULLIF(completed_orders, 0), 2) as revenue_per_completed_order
FROM customer_orders
