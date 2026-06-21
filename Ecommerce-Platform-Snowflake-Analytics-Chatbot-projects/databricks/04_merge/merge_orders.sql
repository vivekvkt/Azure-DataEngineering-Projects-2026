MERGE INTO ecommerce_silver.orders AS tgt

USING (
    SELECT DISTINCT
        CAST(order_id AS INT) AS order_id,
        CAST(customer_id AS INT) AS customer_id,
        CAST(product_id AS INT) AS product_id,
        CAST(quantity AS INT) AS quantity,
        TO_DATE(order_date) AS order_date,
        CAST(total_amount AS DOUBLE) AS total_amount
    FROM ecommerce_bronze.orders
) src

ON tgt.order_id = src.order_id

WHEN MATCHED THEN
UPDATE SET
    tgt.customer_id = src.customer_id,
    tgt.product_id = src.product_id,
    tgt.quantity = src.quantity,
    tgt.order_date = src.order_date,
    tgt.total_amount = src.total_amount

WHEN NOT MATCHED THEN
INSERT (
    order_id,
    customer_id,
    product_id,
    quantity,
    order_date,
    total_amount
)
VALUES (
    src.order_id,
    src.customer_id,
    src.product_id,
    src.quantity,
    src.order_date,
    src.total_amount
);

