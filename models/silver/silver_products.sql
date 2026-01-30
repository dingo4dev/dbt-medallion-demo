{{
    config(
        materialized='view',
        tags=['silver', 'products']
    )
}}

-- Silver layer: Cleaned and validated product data
SELECT
    product_id,
    TRIM(product_name) as product_name,
    TRIM(category) as category,
    ROUND(CAST(price AS DECIMAL(10,2)), 2) as price,
    CASE
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_tier,
    _loaded_at,
    _batch_id
FROM {{ ref('bronze_products') }}
WHERE
    product_id IS NOT NULL
    AND price > 0
