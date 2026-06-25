from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import pandas as pd
import logging
from io import StringIO
from snowflake.connector.pandas_tools import write_pandas


# Reduce noisy logs
logging.getLogger("snowflake").setLevel(logging.ERROR)
logging.getLogger("snowflake.connector").setLevel(logging.ERROR)
logging.getLogger("airflow.providers.snowflake").setLevel(logging.ERROR)
logging.getLogger("airflow.providers.common.sql").setLevel(logging.ERROR)
logging.getLogger("airflow.hooks.base").setLevel(logging.ERROR)

# Configuration
POSTGRES_CONN_ID = 'postgres_insurance'
SNOWFLAKE_CONN_ID = 'snowflake_insurance'
BATCH_ID = f"batch_{datetime.now().strftime('%Y%m%d_%H%M%S')}"

def get_xcom_dataframe(context, task_id, xcom_key):
    """
    Read DataFrame from XCom
    """

    ti = context["ti"]

    json_data = ti.xcom_pull(
        task_ids=task_id,
        key=xcom_key
    )

    if not json_data:
        raise ValueError(
            f"No XCom data found from {task_id}"
        )

    return pd.read_json(StringIO(json_data))

# Extract functions
def extract_customers(**context):

    print("Extracting customers...")

    pg_hook = PostgresHook(
        postgres_conn_id=POSTGRES_CONN_ID
    )

    df = pg_hook.get_pandas_df(
        "SELECT * FROM operational.customers"
    )

    print(f"Extracted {len(df)} customers")

    context["ti"].xcom_push(
        key="customers_data",
        value=df.to_json(orient="records")
    )

    return len(df)

def extract_agents(**context):

    print("Extracting agents...")

    pg_hook = PostgresHook(
        postgres_conn_id=POSTGRES_CONN_ID
    )

    df = pg_hook.get_pandas_df(
        "SELECT * FROM operational.agents"
    )

    print(f"Extracted {len(df)} agents")

    context["ti"].xcom_push(
        key="agents_data",
        value=df.to_json(orient="records")
    )

    return len(df)

def extract_policies(**context):

    print("Extracting policies...")

    pg_hook = PostgresHook(
        postgres_conn_id=POSTGRES_CONN_ID
    )

    df = pg_hook.get_pandas_df(
        "SELECT * FROM operational.policies"
    )

    print(f"Extracted {len(df)} policies")

    context["ti"].xcom_push(
        key="policies_data",
        value=df.to_json(orient="records")
    )

    return len(df)

def extract_claims(**context):

    print("Extracting claims...")

    pg_hook = PostgresHook(
        postgres_conn_id=POSTGRES_CONN_ID
    )

    df = pg_hook.get_pandas_df(
        "SELECT * FROM operational.claims"
    )

    print(f"Extracted {len(df)} claims")

    context["ti"].xcom_push(
        key="claims_data",
        value=df.to_json(orient="records")
    )

    return len(df)

# Load functions
def load_customers_to_snowflake(**context):

    print("STEP 1: Loading customers...")

    df = get_xcom_dataframe(
        context,
        "extract_customers",
        "customers_data"
    )
    print(f"STEP 2: Retrieved {len(df)} rows")
    df["_batch_id"] = BATCH_ID

    print("STEP 3: Creating Snowflake Hook")
    sf_hook = SnowflakeHook(
        snowflake_conn_id=SNOWFLAKE_CONN_ID
    )
    print("STEP 4: Running USE statements")
    print("STEP 4A: USE WAREHOUSE")

    sf_hook.run("USE WAREHOUSE INSURANCE_WH")

    print("STEP 4B: USE DATABASE")

    sf_hook.run("USE DATABASE INSURANCE_DWH")

    print("STEP 4C: USE SCHEMA")

    sf_hook.run("USE SCHEMA BRONZE")

    print("STEP 4D: TRUNCATE")

    sf_hook.run("TRUNCATE TABLE CUSTOMERS")

    print("STEP 4E: TRUNCATE completed")
    sf_hook.run("""
        USE WAREHOUSE INSURANCE_WH;
        USE DATABASE INSURANCE_DWH;
        USE SCHEMA BRONZE;
        TRUNCATE TABLE CUSTOMERS;
    """)
    print("STEP 5: Getting Snowflake connection")
    conn = sf_hook.get_conn()
    print("STEP 6: Connected to Snowflake")
    success, nchunks, nrows, _ = write_pandas(
        conn=conn,
        df=df,
        table_name="CUSTOMERS",
        database="INSURANCE_DWH",
        schema="BRONZE",
        overwrite=False
    )

    if not success:
        raise Exception("Failed loading CUSTOMERS")

    # Validate row count
    count = sf_hook.get_first(
        "SELECT COUNT(*) FROM BRONZE.CUSTOMERS"
    )[0]

    print(f"Expected rows: {len(df)}")
    print(f"Snowflake rows: {count}")

    if count != len(df):
        raise Exception(
            f"CUSTOMERS row count mismatch. "
            f"Expected={len(df)}, Actual={count}"
        )

    conn.close()
    print(f"Loaded {nrows} customers")
    print("STEP 8: Finished")

    return nrows

def load_agents_to_snowflake(**context):

    print("Loading agents...")

    df = get_xcom_dataframe(
        context,
        "extract_agents",
        "agents_data"
    )

    df["_batch_id"] = BATCH_ID

    sf_hook = SnowflakeHook(
        snowflake_conn_id=SNOWFLAKE_CONN_ID
    )

    sf_hook.run("""
        USE WAREHOUSE INSURANCE_WH;
        USE DATABASE INSURANCE_DWH;
        USE SCHEMA BRONZE;
        TRUNCATE TABLE AGENTS;
    """)

    conn = sf_hook.get_conn()

    success, nchunks, nrows, _ = write_pandas(
        conn=conn,
        df=df,
        table_name="AGENTS",
        database="INSURANCE_DWH",
        schema="BRONZE",
        overwrite=False
    )

    if not success:
        raise Exception("Failed loading AGENTS")

    # Validation
    count = sf_hook.get_first(
        "SELECT COUNT(*) FROM BRONZE.AGENTS"
    )[0]

    print(f"Expected rows: {len(df)}")
    print(f"Snowflake rows: {count}")

    if count != len(df):
        raise Exception(
            f"AGENTS row count mismatch. "
            f"Expected={len(df)}, Actual={count}"
        )

    conn.close()
    print(f"Loaded {nrows} agents")
    print("######### Finished ##############")

    return nrows

def load_policies_to_snowflake(**context):

    print("Loading policies...")

    df = get_xcom_dataframe(
        context,
        "extract_policies",
        "policies_data"
    )

    df["_batch_id"] = BATCH_ID

    df.columns = [col.upper() for col in df.columns]
    df["START_DATE"] = pd.to_datetime(df["START_DATE"], unit="ms").dt.date
    df["END_DATE"] = pd.to_datetime(df["END_DATE"], unit="ms").dt.date

    sf_hook = SnowflakeHook(
        snowflake_conn_id=SNOWFLAKE_CONN_ID
    )

    sf_hook.run("""
        USE WAREHOUSE INSURANCE_WH;
        USE DATABASE INSURANCE_DWH;
        USE SCHEMA BRONZE;
        TRUNCATE TABLE POLICIES;
    """)

    conn = sf_hook.get_conn()
    
    success, nchunks, nrows, _ = write_pandas(
        conn=conn,
        df=df,
        table_name="POLICIES",
        database="INSURANCE_DWH",
        schema="BRONZE",
        overwrite=False
    )

    if not success:
        raise Exception("Failed loading POLICIES")

    count = sf_hook.get_first(
        "SELECT COUNT(*) FROM BRONZE.POLICIES"
    )[0]

    print(f"Expected rows: {len(df)}")
    print(f"Snowflake rows: {count}")

    if count != len(df):
        raise Exception(
            f"POLICIES row count mismatch. "
            f"Expected={len(df)}, Actual={count}"
        )

    conn.close()
    print(f"Loaded {nrows} policies")
    print("######### Finished ##############")

    return nrows

def load_claims_to_snowflake(**context):

    print("Loading claims...")

    df = get_xcom_dataframe(
        context,
        "extract_claims",
        "claims_data"
    )

    df["_batch_id"] = BATCH_ID
    df.columns = [col.upper() for col in df.columns]

    df["CLAIM_DATE"] = pd.to_datetime(df["CLAIM_DATE"], unit="ms", errors="coerce").dt.date

    df["INCIDENT_DATE"] = pd.to_datetime(df["INCIDENT_DATE"], unit="ms", errors="coerce").dt.date

    df["PROCESSED_DATE"] = pd.to_datetime(df["PROCESSED_DATE"], unit="ms", errors="coerce").dt.date

    # print(df[["CLAIM_DATE", "INCIDENT_DATE", "PROCESSED_DATE"]].head())
    # print(df.dtypes)


    sf_hook = SnowflakeHook(
        snowflake_conn_id=SNOWFLAKE_CONN_ID
    )

    sf_hook.run("""
        USE WAREHOUSE INSURANCE_WH;
        USE DATABASE INSURANCE_DWH;
        USE SCHEMA BRONZE;
        TRUNCATE TABLE CLAIMS;
    """)

    conn = sf_hook.get_conn()

    # Convert date columns safely
    for col in [
        "claim_date",
        "incident_date",
        "processed_date",
        "created_at",
        "updated_at"
    ]:
        if col in df.columns:
            df[col] = pd.to_datetime(
                df[col],
                errors="coerce"
            )

    success, nchunks, nrows, _ = write_pandas(
        conn=conn,
        df=df,
        table_name="CLAIMS",
        database="INSURANCE_DWH",
        schema="BRONZE",
        overwrite=False
    )

    if not success:
        raise Exception(
            "Failed loading CLAIMS"
        )

    # Validation
    count = sf_hook.get_first(
        "SELECT COUNT(*) FROM BRONZE.CLAIMS"
    )[0]

    print(f"Expected rows: {len(df)}")
    print(f"Snowflake rows: {count}")

    if count != len(df):
        raise Exception(
            f"CLAIMS row count mismatch. "
            f"Expected={len(df)}, Actual={count}"
        )

    conn.close()
    print(f"Loaded {nrows} claims")
    print("######### Finished ##############")

    return nrows

# Validation function
def validate_data_quality(**context):
    """Validate data loaded correctly"""
    print("Validating data quality in Snowflake BRONZE...")
    
    sf_hook = SnowflakeHook(snowflake_conn_id=SNOWFLAKE_CONN_ID)
    
    # Set context
    sf_hook.run("USE WAREHOUSE INSURANCE_WH")
    sf_hook.run("USE DATABASE INSURANCE_DWH")
    sf_hook.run("USE SCHEMA BRONZE")
    
    checks = {
        'customers': "SELECT COUNT(*) FROM CUSTOMERS",
        'agents':  "SELECT COUNT(*) FROM AGENTS",
        'policies': "SELECT COUNT(*) FROM POLICIES",
        'claims': "SELECT COUNT(*) FROM CLAIMS"
    }
    
    results = {}
    for table, sql in checks.items():
        count = sf_hook.get_first(sql)[0]
        results[table] = count

    print("=" * 40)
    print("DATA QUALITY RESULTS")
    print("=" * 40)
    print(f"CUSTOMERS : {results['customers']}")
    print(f"AGENTS    : {results['agents']}")
    print(f"POLICIES  : {results['policies']}")
    print(f"CLAIMS    : {results['claims']}")
    print("=" * 40)
    print("✅ Validation Passed")
    
    if results['customers'] == 0 or results['claims'] == 0:
        raise ValueError("Data validation failed: No records found!")
    
    print("✅ Data quality validation passed!")
    return results

def send_success_notification(**context):
    """Send success notification"""
    print("=" * 60)
    print("🎉 ETL PIPELINE COMPLETED SUCCESSFULLY!")
    print("=" * 60)
    print(f"Batch ID: {BATCH_ID}")
    print(f"Execution Date: {context['ds']}")
    print("Data successfully loaded to Snowflake BRONZE layer")
    print("Next: dbt will transform BRONZE → SILVER → GOLD")
    print("=" * 60)
    return "Pipeline completed successfully"

# Define DAG
default_args = {
    'owner': 'data_engineering_team',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,  # Changed to 0 for faster testing
    'retry_delay': timedelta(minutes=1),
}

with DAG(
    dag_id='etl_postgres_to_snowflake',
    default_args=default_args,
    description='ETL Pipeline: PostgreSQL → Snowflake BRONZE (Medallion Architecture)',
    schedule_interval='0 2 * * *',
    start_date=datetime(2024, 10, 1),
    catchup=False,
    tags=['etl', 'postgres', 'snowflake', 'bronze', 'insurance']
) as dag:
    
    extract_customers_task = PythonOperator(task_id='extract_customers', python_callable=extract_customers)
    extract_agents_task = PythonOperator(task_id='extract_agents', python_callable=extract_agents)
    extract_policies_task = PythonOperator(task_id='extract_policies', python_callable=extract_policies)
    extract_claims_task = PythonOperator(task_id='extract_claims', python_callable=extract_claims)
    
    load_customers_task = PythonOperator(task_id='load_customers_to_snowflake', python_callable=load_customers_to_snowflake)
    load_agents_task = PythonOperator(task_id='load_agents_to_snowflake', python_callable=load_agents_to_snowflake)
    load_policies_task = PythonOperator(task_id='load_policies_to_snowflake', python_callable=load_policies_to_snowflake)
    load_claims_task = PythonOperator(task_id='load_claims_to_snowflake', python_callable=load_claims_to_snowflake)
    
    validate_task = PythonOperator(task_id='validate_data_quality', python_callable=validate_data_quality)
    notify_task = PythonOperator(task_id='send_success_notification', python_callable=send_success_notification)
    
    # Dependencies
    extract_customers_task >> load_customers_task
    extract_agents_task >> load_agents_task
    extract_policies_task >> load_policies_task
    extract_claims_task >> load_claims_task
    
    [load_customers_task, load_agents_task, load_policies_task, load_claims_task] >> validate_task >> notify_task