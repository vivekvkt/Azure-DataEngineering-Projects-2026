{{ config(materialized='table') }}

SELECT *
FROM {{ source('ecommerce','SALES_ANALYTICS') }}

---dbt run --select mart_ai_dashboard