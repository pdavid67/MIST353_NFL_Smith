import os
import pyodbc
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    server = os.getenv('DB_SERVER')
    database = os.getenv('DB_NAME')
    username = os.getenv('DB_LOGIN')
    password = os.getenv('DB_PASSWORD')

    connection_string = f"Driver={{ODBC Driver 18 for SQL Server}};Server={server};Database={database};UID={username};PWD={password};"
    return pyodbc.connect(connection_string)

import pyodbc
print(pyodbc.drivers())
