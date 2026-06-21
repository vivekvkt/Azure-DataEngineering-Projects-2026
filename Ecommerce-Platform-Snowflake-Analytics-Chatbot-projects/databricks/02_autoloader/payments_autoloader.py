from pyspark.sql.types import *

payment_schema = StructType([
    StructField("payment_id", IntegerType(), True),
    StructField("order_id", IntegerType(), True),
    StructField("amount", DoubleType(), True),
    StructField("payment_method", StringType(), True),
    StructField("payment_date", StringType(), True)
])

df_payments = (
    spark.readStream
         .format("cloudFiles")
         .option("cloudFiles.format", "csv")
         .option("header", "true")
         .schema(payment_schema)
         .load("/Volumes/dedatabricsws/demo/raw_volume/payments")
)



(
df.writeStream
.format("delta")
.option(
"checkpointLocation",
"/Volumes/dedatabricsws/demo/raw_volume/checkpoints/payments"
)
.trigger(availableNow=True)
.toTable("ecommerce_bronze.payments")
)