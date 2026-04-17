import os
from pathlib import Path

import pyodbc
from dotenv import load_dotenv

ENV_PATH = Path(__file__).resolve().with_name(".env")
load_dotenv(dotenv_path=ENV_PATH)

def get_db_connection():
    server = os.getenv('DB_SERVER')
    database = os.getenv('DB_NAME')
    username = os.getenv('DB_LOGIN')
    password = os.getenv('DB_PASSWORD')

    missing = [
        name
        for name, value in {
            "DB_SERVER": server,
            "DB_NAME": database,
            "DB_LOGIN": username,
            "DB_PASSWORD": password,
        }.items()
        if not value
    ]
    if missing:
        raise RuntimeError(f"Missing database configuration: {', '.join(missing)}")

    available_drivers = set(pyodbc.drivers())
    preferred_drivers = [
        "ODBC Driver 18 for SQL Server",
        "ODBC Driver 17 for SQL Server",
    ]
    drivers_to_try = [driver for driver in preferred_drivers if driver in available_drivers]

    if not drivers_to_try:
        raise RuntimeError("No supported SQL Server ODBC driver found. Install ODBC Driver 17 or 18.")

    last_error = None
    for driver in drivers_to_try:
        connection_string = (
            f"Driver={{{driver}}};"
            f"Server={server};"
            f"Database={database};"
            f"UID={username};"
            f"PWD={password};"
            "Encrypt=yes;"
            "TrustServerCertificate=no;"
        )

        try:
            return pyodbc.connect(connection_string, timeout=30)
        except pyodbc.Error as exc:
            last_error = exc

    raise RuntimeError(f"Database connection failed: {last_error}")
