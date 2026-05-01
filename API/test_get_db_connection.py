import os

from dotenv import load_dotenv

from get_db_connection import get_db_connection


load_dotenv("API/.env")


def test_get_db_connection():
    required_vars = ["DB_SERVER", "DB_NAME"]
    missing = [name for name in required_vars if not os.getenv(name)]
    assert not missing, f"Missing env vars: {missing}"
    print("Env vars loaded")

    conn = get_db_connection()
    assert conn is not None, "Expected a database connection"
    print("Connection object returned")

    cursor = conn.cursor()
    cursor.execute("SELECT 1")
    result = cursor.fetchone()
    assert result[0] == 1, "Expected query result of 1"
    print("Connection is live and queryable")

    conn.close()
    print("Connection closed cleanly")
    print("\nAll tests passed!")


if __name__ == "__main__":
    test_get_db_connection()
