SELECT 
    c.customer_id,
    c.total_revenue,
    p.total_orders,
    d.daily_revenue,
    d.order_date
FROM {{ ref('stg_customer_revenue') }} c
LEFT JOIN {{ ref('stg_product_sales') }} p
    ON 1=1
LEFT JOIN {{ ref('stg_daily_revenue') }} d
    ON 1=1