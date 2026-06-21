def generate_sql(user_question):
    """
    Mock AI that converts English to SQL
    """

    if "sales" in user_question.lower():
        return "SELECT * FROM sales WHERE amount > 1000;"

    elif "customer" in user_question.lower():
        return "SELECT * FROM customers WHERE country = 'India';"

    elif "top" in user_question.lower():
        return """
        SELECT product_id, SUM(amount) as total_sales
        FROM sales
        GROUP BY product_id
        ORDER BY total_sales DESC
        LIMIT 10;
        """

    else:
        return "SELECT 'No matching SQL rule found' AS message;"