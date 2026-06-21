from chatbot import chatbot

def main():
    print("===================================")
    print("  SNOWFLAKE ANALYTICS CHATBOT")
    print("===================================")

    print("\nAsk questions like:")
    print("- total sales")
    print("- top customer")
    print("- city wise sales")
    print("- product sales")
    print("- completed orders\n")

    while True:
        q = input("Ask: ")

        if q.lower() == "exit":
            break

        response = chatbot(q)

        print("\nAnswer:", response)
        print("---------------------------------\n")


if __name__ == "__main__":
    main()