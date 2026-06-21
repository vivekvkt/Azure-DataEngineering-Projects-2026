SELECT 
    product_id,
    total_orders
FROM {{ ref('stg_product_sales') }}