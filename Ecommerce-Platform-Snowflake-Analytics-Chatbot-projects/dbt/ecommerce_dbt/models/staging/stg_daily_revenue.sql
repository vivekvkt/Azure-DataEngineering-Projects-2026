SELECT

    order_date,

    daily_revenue

FROM {{ source('ecommerce','DAILY_REVENUE_V2') }}