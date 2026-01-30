{{
    config(
        materialized='view',
        tags=['bronze', 'customers']
    )
}}

-- Bronze layer: Raw customer data with basic metadata
SELECT
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    CURRENT_TIMESTAMP as _loaded_at,
    '{{ invocation_id }}' as _batch_id
FROM {{ ref('raw_customers') }}
