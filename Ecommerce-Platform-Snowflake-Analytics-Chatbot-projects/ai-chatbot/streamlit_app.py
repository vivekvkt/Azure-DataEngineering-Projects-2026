import streamlit as st
from chatbot import chatbot

st.set_page_config(page_title="Snowflake Analytics Bot")

st.title("🤖 Snowflake Analytics Chatbot")

st.write("Ask questions about sales, customers, products, and cities.")

question = st.text_input("Ask a question:")

if st.button("Submit"):

    if question:

        response = chatbot(question)

        st.subheader("Question")
        st.write(response["question"])

        st.subheader("SQL Used")
        st.code(response["sql"], language="sql")

        st.subheader("Answer")
        st.write(response["answer"])