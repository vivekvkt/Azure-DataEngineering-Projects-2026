import os
from dotenv import load_dotenv
import snowflake.connector
import pandas as pd

load_dotenv()

def get_connection():

    conn = snowflake.connector.connect(
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
        database=os.getenv("SNOWFLAKE_DATABASE"),
        schema=os.getenv("SNOWFLAKE_SCHEMA")
    )

    return conn


def fetch_data(query):
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute(query)

    df = pd.DataFrame(cursor.fetchall(),
                      columns=[col[0] for col in cursor.description])

    cursor.close()
    conn.close()

    return df