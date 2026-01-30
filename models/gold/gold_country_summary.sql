{{
    config(
        materialized='table',
        tags=['gold', 'country-analytics']
    )
}}

-- Gold layer: Country-level analytics
SELECT
    c.country,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(o.order_id) as total_orders,
    COUNT(CASE WHEN o.is_completed THEN 1 END) as completed_orders,
    SUM(CASE WHEN o.is_completed THEN o.order_amount ELSE 0 END) as total_revenue,
    AVG(CASE WHEN o.is_completed THEN o.order_amount END) as avg_order_value,
    ROUND(
        SUM(CASE WHEN o.is_completed THEN o.order_amount ELSE 0 END) /
        NULLIF(COUNT(DISTINCT c.customer_id), 0),
        2
    ) as revenue_per_customer
FROM {{ ref('silver_customers') }} c
LEFT JOIN {{ ref('silver_orders') }} o
    ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC
