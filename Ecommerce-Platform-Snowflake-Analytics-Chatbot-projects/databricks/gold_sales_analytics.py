from pyspark.sql.functions import *
from pyspark.sql.types import IntegerType

orders = spark.table("ecommerce_silver.orders")
customers = spark.table("ecommerce_silver.customers")
products = spark.table("ecommerce_silver.products")
payments = spark.table("ecommerce_silver.payments")

# datatype alignment
orders = orders.withColumn(
    "customer_id",
    col("customer_id").cast(IntegerType())
)

sales_analytics = (
    orders.alias("o")
    .join(
        customers.alias("c"),
        col("o.customer_id") == col("c.customer_id"),
        "left"
    )
    .join(
        products.alias("p"),
        col("o.product_id") == col("p.product_id"),
        "left"
    )
    .join(
        payments.alias("pay"),
        col("o.order_id").cast("string") == col("pay.order_id"),
        "left"
    )
)


## select business 
gold_df = sales_analytics.select(
    col("o.order_id"),
    col("o.order_date"),
    col("o.customer_id"),
    col("c.customer_name"),
    col("c.city"),
    col("c.country"),
    col("o.product_id"),
    col("p.product_name"),
    col("p.category"),
    col("o.quantity"),
    col("o.total_amount"),
    col("pay.payment_method"),
    col("pay.payment_status")
)

gold_df.write \
    .mode("overwrite") \
    .saveAsTable("ecommerce_gold.sales_analytics")


display(
    spark.sql("""
        SELECT *
        FROM ecommerce_gold.sales_analytics
        LIMIT 10
    """)
)


df_gold = spark.table("ecommerce_gold.sales_analytics")

df_gold.show(5)
df_gold.count()

snowflake_options = {
  "host": "snowflakecomputing.com",
  "port": 443,
  "sfUser": "snowDream",
  "sfPassword":  "1234",
  "sfDatabase": "ECOMMERCE_DB",
  "sfSchema": "PUBLIC",
  "sfWarehouse": "COMPUTE_WH"
}

df_gold.write \
    .format("snowflake") \
    .options(**snowflake_options) \
    .option("dbtable", "SALES_ANALYTICS") \
    .mode("overwrite") \
    .save()