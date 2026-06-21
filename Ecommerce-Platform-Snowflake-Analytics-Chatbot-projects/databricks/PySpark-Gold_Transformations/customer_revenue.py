customer_revenue = (
    orders.join(payments, "order_id")
    .groupBy("customer_id")
    .sum("amount")
    .withColumnRenamed("sum(amount)", "total_revenue")
)

customer_revenue.write \
    .mode("overwrite") \
    .saveAsTable("ecommerce_gold.customer_revenue_v2")