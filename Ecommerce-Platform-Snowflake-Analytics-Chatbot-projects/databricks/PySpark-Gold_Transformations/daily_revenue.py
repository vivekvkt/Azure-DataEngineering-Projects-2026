from pyspark.sql.functions import to_date

daily_revenue = (
    orders.join(payments, "order_id")
    .withColumn("order_date", to_date("order_date"))
    .groupBy("order_date")
    .sum("amount")
    .withColumnRenamed("sum(amount)", "daily_revenue")
)

daily_revenue.write \
    .mode("overwrite") \
    .saveAsTable("ecommerce_gold.daily_revenue_v2")