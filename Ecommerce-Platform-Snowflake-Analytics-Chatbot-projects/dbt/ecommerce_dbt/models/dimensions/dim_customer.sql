SELECT DISTINCT

    customer_id

FROM {{ ref('stg_customer_revenue') }}