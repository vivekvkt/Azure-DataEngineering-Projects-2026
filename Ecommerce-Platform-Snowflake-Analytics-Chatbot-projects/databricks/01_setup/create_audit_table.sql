CREATE TABLE IF NOT EXISTS ecommerce_gold.pipeline_audit
(
 run_id STRING,
 table_name STRING,
 source_count BIGINT,
 target_count BIGINT,
 status STRING,
 load_timestamp TIMESTAMP
)
USING DELTA;