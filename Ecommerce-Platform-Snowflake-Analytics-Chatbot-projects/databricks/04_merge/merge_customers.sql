MERGE INTO ecommerce_silver.customers AS tgt

USING (

    SELECT DISTINCT
        CAST(customer_id AS INT)      AS customer_id,
        customer_name,
        city
    FROM ecommerce_bronze.customers

) AS src

ON tgt.customer_id = src.customer_id

WHEN MATCHED THEN
UPDATE SET
    tgt.customer_name = src.customer_name,
    tgt.city          = src.city

WHEN NOT MATCHED THEN
INSERT
(
    customer_id,
    customer_name,
    city
)
VALUES
(
    src.customer_id,
    src.customer_name,
    src.city
);