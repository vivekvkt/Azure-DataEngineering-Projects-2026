product_sales = (
    orders.groupBy("product_id")
    .count()
    .withColumnRenamed("count", "total_orders")
)

product_sales.write \
    .mode("overwrite") \
    .saveAsTable("ecommerce_gold.product_sales_v2")