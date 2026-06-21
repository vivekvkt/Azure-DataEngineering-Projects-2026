MERGE INTO ecommerce_silver.products AS tgt

USING (

    SELECT DISTINCT
        CAST(product_id AS INT) AS product_id,
        product_name,
        category,
        CAST(price AS DOUBLE) AS price
    FROM ecommerce_bronze.products

) AS src

ON tgt.product_id = src.product_id

WHEN MATCHED THEN
UPDATE SET
    tgt.product_name = src.product_name,
    tgt.category     = src.category,
    tgt.price        = src.price

WHEN NOT MATCHED THEN
INSERT
(
    product_id,
    product_name,
    category,
    price
)
VALUES
(
    src.product_id,
    src.product_name,
    src.category,
    src.price
);