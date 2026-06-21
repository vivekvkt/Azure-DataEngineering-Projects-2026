from pyspark.sql.types import *

order_schema = StructType([
    StructField("order_id", IntegerType(), True),
    StructField("customer_id", IntegerType(), True),
    StructField("product_id", IntegerType(), True),
    StructField("quantity", IntegerType(), True),
    StructField("order_date", StringType(), True),
    StructField("total_amount", DoubleType(), True)
])

df_orders = (
    spark.readStream
         .format("cloudFiles")
         .option("cloudFiles.format", "csv")
         .option("header", "true")
         .schema(order_schema)
         .load("/Volumes/dedatabricsws/demo/raw_volume/orders")
)



(
df.writeStream
.format("delta")
.option(
"checkpointLocation",
"/Volumes/dedatabricsws/demo/raw_volume/checkpoints/orders"
)
.trigger(availableNow=True)
.toTable("ecommerce_bronze.orders")
)