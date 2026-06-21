Airflow Scheduler
        ↓
Databricks Processing
        ↓
Snowflake Load
        ↓
dbt Run
        ↓
dbt Test
        ↓
MART_AI_DASHBOARD Refresh
        ↓
Streamlit Analytics Chatbot


Purpose
Schedule daily pipeline execution
Manage task dependencies
Automate dbt transformations
Automate data quality checks
Ensure chatbot always reads latest curated data

ADLS Gen2
     ↓
Databricks
     ↓
Snowflake
     ↓
dbt
     ↓
MART_AI_DASHBOARD
     ↓
Python Chatbot
     ↓
Streamlit UI

Airflow
     ↓
Orchestrates entire pipeline