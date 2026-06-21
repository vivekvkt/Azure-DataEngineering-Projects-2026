SELECT DISTINCT

    product_id

FROM {{ ref('stg_product_sales') }}