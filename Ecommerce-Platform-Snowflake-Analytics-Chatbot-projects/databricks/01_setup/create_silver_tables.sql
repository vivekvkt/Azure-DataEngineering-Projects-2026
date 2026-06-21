CREATE TABLE IF NOT EXISTS ecommerce_silver.customers
(
 customer_id INT,
 customer_name STRING,
 city STRING
)
USING DELTA;

CREATE TABLE IF NOT EXISTS ecommerce_silver.orders
(
 order_id INT,
 customer_id INT,
 product_id INT,
 quantity INT,
 order_date DATE,
 total_amount DOUBLE
)
USING DELTA;

CREATE TABLE IF NOT EXISTS ecommerce_silver.products
(
 product_id INT,
 product_name STRING,
 category STRING,
 price DOUBLE
)
USING DELTA;

CREATE TABLE IF NOT EXISTS ecommerce_silver.payments
(
 payment_id INT,
 order_id INT,
 amount DOUBLE,
 payment_method STRING,
 payment_date DATE
)
USING DELTA;