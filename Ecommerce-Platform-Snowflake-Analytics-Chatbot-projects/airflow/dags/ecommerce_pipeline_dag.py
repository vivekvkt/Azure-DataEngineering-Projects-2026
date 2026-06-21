from datetime import datetime

# Airflow imports
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="ecommerce_analytics_pipeline",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["ecommerce", "snowflake", "dbt"],
) as dag:

    # Step 1 - Databricks Processing
    databricks_job = BashOperator(
        task_id="run_databricks_job",
        bash_command="echo Running Databricks Bronze-Silver-Gold Pipeline"
    )

    # Step 2 - Snowflake Load
    snowflake_load = BashOperator(
        task_id="load_to_snowflake",
        bash_command="echo Loading curated data into Snowflake"
    )

    # Step 3 - dbt Run
    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="echo Running dbt models"
    )

    # Step 4 - dbt Test
    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="echo Running dbt tests"
    )

    # Step 5 - Refresh Mart
    refresh_dashboard = BashOperator(
        task_id="refresh_mart_ai_dashboard",
        bash_command="echo Refreshing MART_AI_DASHBOARD"
    )

    (
        databricks_job
        >> snowflake_load
        >> dbt_run
        >> dbt_test
        >> refresh_dashboard
    )