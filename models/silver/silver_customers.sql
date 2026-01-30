{{
    config(
        materialized='view',
        tags=['silver', 'customers']
    )
}}

-- Silver layer: Cleaned and validated customer data
SELECT
    customer_id,
    UPPER(TRIM(customer_name)) as customer_name,
    LOWER(TRIM(email)) as email,
    UPPER(TRIM(country)) as country,
    CAST(signup_date AS DATE) as signup_date,
    _loaded_at,
    _batch_id
FROM {{ ref('bronze_customers') }}
WHERE
    customer_id IS NOT NULL
    AND email IS NOT NULL
    AND email LIKE '%@%'  -- Basic email validation
