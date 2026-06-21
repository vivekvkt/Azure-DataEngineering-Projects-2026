SELECT

    customer_id,

    total_revenue

FROM {{ ref('stg_customer_revenue') }}