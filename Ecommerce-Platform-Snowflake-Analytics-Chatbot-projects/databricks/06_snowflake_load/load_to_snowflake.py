### snowflake connection

snowflake_options = {
  "host": "snowflakecomputing.com",
  "port": 443,
  "sfUser": "snowDream",
  "sfPassword":  "",
  "sfDatabase": "ECOMMERCE_DB",
  "sfSchema": "PUBLIC",
  "sfWarehouse": "COMPUTE_WH"
}

df_gold = spark.table(
"ecommerce_gold.CUSTOMER_REVENUE_V2"
)

df_gold.write \
.format("snowflake") \
.options(**snowflake_options) \
.option(
"dbtable",
"CUSTOMER_REVENUE_V2"
) \
.mode("overwrite") \
.save()



df_gold = spark.table(
"ecommerce_gold.PRODUCT_SALES_V2"
)

df_gold.write \
.format("snowflake") \
.options(**snowflake_options) \
.option(
"dbtable",
"PRODUCT_SALES_V2"
) \
.mode("overwrite") \
.save()


df_gold = spark.table(
"ecommerce_gold.DAILY_REVENUE_V2"
)

df_gold.write \
.format("snowflake") \
.options(**snowflake_options) \
.option(
"dbtable",
"DAILY_REVENUE_V2"
) \
.mode("overwrite") \
.save()