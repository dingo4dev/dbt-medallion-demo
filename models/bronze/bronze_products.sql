{{
    config(
        materialized='view',
        tags=['bronze', 'products']
    )
}}

-- Bronze layer: Raw product data with basic metadata
SELECT
    product_id,
    product_name,
    category,
    price,
    CURRENT_TIMESTAMP as _loaded_at,
    '{{ invocation_id }}' as _batch_id
FROM {{ ref('raw_products') }}
