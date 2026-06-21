MERGE INTO ecommerce_silver.payments AS tgt

USING (

    SELECT DISTINCT
        CAST(payment_id AS INT) AS payment_id,
        CAST(order_id AS INT)   AS order_id,
        CAST(amount AS DOUBLE)  AS amount,
        payment_method,
        payment_date
    FROM ecommerce_bronze.payments

) AS src

ON tgt.payment_id = src.payment_id

WHEN MATCHED THEN
UPDATE SET
    tgt.order_id       = src.order_id,
    tgt.amount         = src.amount,
    tgt.payment_method = src.payment_method,
    tgt.payment_date   = src.payment_date

WHEN NOT MATCHED THEN
INSERT
(
    payment_id,
    order_id,
    amount,
    payment_method,
    payment_date
)
VALUES
(
    src.payment_id,
    src.order_id,
    src.amount,
    src.payment_method,
    src.payment_date
);