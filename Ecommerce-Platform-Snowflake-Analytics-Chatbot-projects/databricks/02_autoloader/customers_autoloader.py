from pyspark.sql.types import *

schema = StructType([
    StructField("customer_id", IntegerType()),
    StructField("customer_name", StringType()),
    StructField("city", StringType())
])

df = (
 spark.readStream
 .format("cloudFiles")
 .option("cloudFiles.format","csv")
 .option("header","true")
 .schema(schema)
 .load("/Volumes/dedatabricsws/demo/raw_volume/customers")
)

(
df.writeStream
.format("delta")
.option(
"checkpointLocation",
"/Volumes/dedatabricsws/demo/raw_volume/checkpoints/customers"
)
.trigger(availableNow=True)
.toTable("ecommerce_bronze.customers")
)