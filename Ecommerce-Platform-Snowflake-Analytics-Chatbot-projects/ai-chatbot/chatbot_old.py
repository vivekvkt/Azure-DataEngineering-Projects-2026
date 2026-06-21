from snowflake_connection import fetch_data

def get_data():
    query = "SELECT * FROM DBT_DEV.MART_AI_DASHBOARD"
    return fetch_data(query)


def chatbot(question):
    df = get_data()

    q = question.lower()

    # 1️⃣ Total sales
    if "total sales" in q:
        return f"Total Sales = {df['TOTAL_AMOUNT'].sum()}"

    # 2️⃣ Top customer
    elif "top customer" in q:
        result = df.groupby("CUSTOMER_NAME")["TOTAL_AMOUNT"].sum().idxmax()
        return f"Top Customer = {result}"

    # 3️⃣ city wise sales
    elif "city" in q:
        result = df.groupby("CITY")["TOTAL_AMOUNT"].sum().to_dict()
        return result

    # 4️⃣ product wise sales
    elif "product" in q:
        result = df.groupby("PRODUCT_NAME")["TOTAL_AMOUNT"].sum().to_dict()
        return result

    # 5️⃣ completed orders
    elif "completed" in q:
        count = df[df["PAYMENT_STATUS"] == "Completed"].shape[0]
        return f"Completed Orders = {count}"

    # default
    else:
        return "I can answer: sales, customer, product, city, payment status"