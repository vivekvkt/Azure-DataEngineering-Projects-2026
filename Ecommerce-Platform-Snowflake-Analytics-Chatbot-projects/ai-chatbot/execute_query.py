def run_query(sql):
    print("\n🚀 Executing SQL (MOCK MODE)")
    print("------------------------------------------------")
    print(sql)
    print("------------------------------------------------")

    # Fake result
    return [
        {"id": 1, "value": "Sample Result A"},
        {"id": 2, "value": "Sample Result B"}
    ]

# import pandas as pd

# from snowflake_connection import get_connection

# def run_query(sql_query):

#     conn = get_connection()

#     try:

#         df = pd.read_sql(sql_query, conn)

#         return df

#     finally:

#         conn.close()