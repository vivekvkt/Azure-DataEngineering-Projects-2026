from pyspark.sql.types import *

product_schema = StructType([
    StructField("product_id", IntegerType(), True),
    StructField("product_name", StringType(), True),
    StructField("category", StringType(), True),
    StructField("price", DoubleType(), True)
])

df_products = (
    spark.readStream
         .format("cloudFiles")
         .option("cloudFiles.format", "csv")
         .option("header", "true")
         .schema(product_schema)
         .load("/Volumes/dedatabricsws/demo/raw_volume/products")
)



(
df.writeStream
.format("delta")
.option(
"checkpointLocation",
"/Volumes/dedatabricsws/demo/raw_volume/checkpoints/products"
)
.trigger(availableNow=True)
.toTable("ecommerce_bronze.products")
)