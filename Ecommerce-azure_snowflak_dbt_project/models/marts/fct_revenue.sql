SELECT 
    c.customer_id,
    c.total_revenue,
    p.total_orders
FROM {{ ref('stg_customer_revenue') }} c
LEFT JOIN {{ ref('stg_product_sales') }} p
    ON 1=1