from mock_openai_client import generate_sql

def convert_text_to_sql(user_input):
    sql = generate_sql(user_input)
    return sql




# from openai_client import client
# from openai_client import deployment_name

# def generate_sql(question):

#     prompt = f"""
# You are an expert Snowflake SQL developer.

# Table Name:
# MART_AI_DASHBOARD

# Columns:

# ORDER_ID
# ORDER_DATE
# CUSTOMER_ID
# CUSTOMER_NAME
# CITY
# COUNTRY
# PRODUCT_ID
# PRODUCT_NAME
# CATEGORY
# QUANTITY
# TOTAL_AMOUNT
# PAYMENT_METHOD
# PAYMENT_STATUS

# Rules:
# 1. Generate only Snowflake SQL.
# 2. Use MART_AI_DASHBOARD table only.
# 3. Do not provide explanation.
# 4. Return only SQL query.

# Question:
# {question}
# """

#     response = client.chat.completions.create(
#         model=deployment_name,
#         messages=[
#             {
#                 "role": "user",
#                 "content": prompt
#             }
#         ],
#         temperature=0
#     )

#     sql_query = response.choices[0].message.content.strip()

#     sql_query = sql_query.replace("```sql", "")
#     sql_query = sql_query.replace("```", "")

#     return sql_query