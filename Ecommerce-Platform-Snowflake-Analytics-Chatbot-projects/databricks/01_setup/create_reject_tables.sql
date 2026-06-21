CREATE TABLE IF NOT EXISTS ecommerce_reject.customers
AS SELECT * FROM ecommerce_bronze.customers WHERE 1=2;

CREATE TABLE IF NOT EXISTS ecommerce_reject.orders
AS SELECT * FROM ecommerce_bronze.orders WHERE 1=2;

CREATE TABLE IF NOT EXISTS ecommerce_reject.products
AS SELECT * FROM ecommerce_bronze.products WHERE 1=2;

CREATE TABLE IF NOT EXISTS ecommerce_reject.payments
AS SELECT * FROM ecommerce_bronze.payments WHERE 1=2;