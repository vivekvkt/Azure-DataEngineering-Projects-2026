from snowflake_connection import fetch_data

def get_data():
    query = """
    SELECT *
    FROM DBT_DEV.MART_AI_DASHBOARD
    """
    return fetch_data(query)


def chatbot(question):

    df = get_data()
    q = question.lower()

    # Total Sales
    if "total sales" in q:

        sql = """
        SELECT SUM(TOTAL_AMOUNT) AS TOTAL_SALES
        FROM DBT_DEV.MART_AI_DASHBOARD
        """

        total_sales = df["TOTAL_AMOUNT"].sum()

        return {
            "question": question,
            "sql": sql,
            "answer": f"Total Sales = ₹{total_sales:,.2f}"
        }

    # Top Customer
    elif "top customer" in q:

        sql = """
        SELECT CUSTOMER_NAME,
               SUM(TOTAL_AMOUNT) AS TOTAL_SPEND
        FROM DBT_DEV.MART_AI_DASHBOARD
        GROUP BY CUSTOMER_NAME
        ORDER BY TOTAL_SPEND DESC
        LIMIT 1
        """

        customer_sales = (
            df.groupby("CUSTOMER_NAME")["TOTAL_AMOUNT"]
            .sum()
            .sort_values(ascending=False)
        )

        top_customer = customer_sales.index[0]
        top_amount = customer_sales.iloc[0]

        return {
            "question": question,
            "sql": sql,
            "answer": f"{top_customer} (₹{top_amount:,.2f})"
        }

    # Total Orders
    elif "total orders" in q:

        sql = """
        SELECT COUNT(*) AS TOTAL_ORDERS
        FROM DBT_DEV.MART_AI_DASHBOARD
        """

        total_orders = len(df)

        return {
            "question": question,
            "sql": sql,
            "answer": f"Total Orders = {total_orders}"
        }

    # Completed Orders
    elif "completed orders" in q:

        sql = """
        SELECT COUNT(*) AS COMPLETED_ORDERS
        FROM DBT_DEV.MART_AI_DASHBOARD
        WHERE PAYMENT_STATUS='Completed'
        """

        completed = len(
            df[df["PAYMENT_STATUS"] == "Completed"]
        )

        return {
            "question": question,
            "sql": sql,
            "answer": f"Completed Orders = {completed}"
        }

    # Top Product
    elif "top product" in q:

        sql = """
        SELECT PRODUCT_NAME,
               SUM(TOTAL_AMOUNT) AS SALES
        FROM DBT_DEV.MART_AI_DASHBOARD
        GROUP BY PRODUCT_NAME
        ORDER BY SALES DESC
        LIMIT 1
        """

        product_sales = (
            df.groupby("PRODUCT_NAME")["TOTAL_AMOUNT"]
            .sum()
            .sort_values(ascending=False)
        )

        top_product = product_sales.index[0]
        top_sales = product_sales.iloc[0]

        return {
            "question": question,
            "sql": sql,
            "answer": f"{top_product} (₹{top_sales:,.2f})"
        }

    # City Wise Sales
    elif "city wise sales" in q:

        sql = """
        SELECT CITY,
               SUM(TOTAL_AMOUNT) AS SALES
        FROM DBT_DEV.MART_AI_DASHBOARD
        GROUP BY CITY
        ORDER BY SALES DESC
        """

        city_sales = (
            df.groupby("CITY")["TOTAL_AMOUNT"]
            .sum()
            .sort_values(ascending=False)
            .head(10)
            .to_dict()
        )

        return {
            "question": question,
            "sql": sql,
            "answer": city_sales
        }

    # Default Response
    else:

        return {
            "question": question,
            "sql": "N/A",
            "answer": """
Supported Questions:

• total sales
• top customer
• total orders
• completed orders
• top product
• city wise sales
"""
        }