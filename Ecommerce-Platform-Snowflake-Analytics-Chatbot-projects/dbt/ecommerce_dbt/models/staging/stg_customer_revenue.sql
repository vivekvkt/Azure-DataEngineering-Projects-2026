SELECT

    customer_id,

    total_revenue

FROM {{ source('ecommerce','CUSTOMER_REVENUE_V2') }}