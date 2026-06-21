SELECT

    product_id,

    total_orders

FROM {{ source('ecommerce','PRODUCT_SALES_V2') }}