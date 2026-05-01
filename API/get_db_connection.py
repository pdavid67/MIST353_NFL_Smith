import os
from importlib import import_module
from pathlib import Path
from typing import Optional

from dotenv import load_dotenv

ENV_PATH = Path(__file__).resolve().with_name(".env")
load_dotenv(dotenv_path=ENV_PATH)


def _env_bool(name: str, default: bool = False) -> bool:
    value = os.getenv(name)
    if value is None:
        return default
    return value.strip().lower() in {"1", "true", "yes", "y"}


def _connect_with_pyodbc(
    server: str,
    database: str,
    username: Optional[str],
    password: Optional[str],
    trusted_connection: bool,
    encrypt: bool,
    trust_server_certificate: bool,
):
    pyodbc = import_module("pyodbc")

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
        if trusted_connection:
            auth_part = "Trusted_Connection=yes;"
        else:
            if not username or not password:
                raise RuntimeError("DB_LOGIN and DB_PASSWORD are required when DB_TRUSTED_CONNECTION=false.")
            auth_part = f"UID={username};PWD={password};"

        connection_string = (
            f"Driver={{{driver}}};"
            f"Server={server};"
            f"Database={database};"
            f"{auth_part}"
            f"Encrypt={'yes' if encrypt else 'no'};"
            f"TrustServerCertificate={'yes' if trust_server_certificate else 'no'};"
        )

        try:
            return pyodbc.connect(connection_string, timeout=30)
        except pyodbc.Error as exc:
            last_error = exc

    raise RuntimeError(f"Database connection failed with pyodbc: {last_error}")


def _connect_with_pymssql(
    server: str,
    database: str,
    username: Optional[str],
    password: Optional[str],
    encrypt: bool,
):
    if not username or not password:
        raise RuntimeError("pymssql requires DB_LOGIN and DB_PASSWORD.")

    pymssql = import_module("pymssql")

    connect_kwargs = {
        "server": server,
        "user": username,
        "password": password,
        "database": database,
        "port": os.getenv("DB_PORT", "1433"),
        "login_timeout": 30,
        "timeout": 30,
        "tds_version": os.getenv("DB_TDS_VERSION", "7.4"),
    }
    if encrypt:
        connect_kwargs["encryption"] = "require"

    return pymssql.connect(**connect_kwargs)


def get_db_connection():
    server = os.getenv("DB_SERVER", "localhost")
    database = os.getenv("DB_NAME", "MIST353_NFL_Smith")
    username = os.getenv("DB_LOGIN")
    password = os.getenv("DB_PASSWORD")
    trusted_connection = _env_bool("DB_TRUSTED_CONNECTION", not (username and password))
    encrypt = _env_bool("DB_ENCRYPT", False)
    trust_server_certificate = _env_bool("DB_TRUST_SERVER_CERTIFICATE", True)

    missing = [
        name
        for name, value in {
            "DB_SERVER": server,
            "DB_NAME": database,
        }.items()
        if not value
    ]
    if missing:
        raise RuntimeError(f"Missing database configuration: {', '.join(missing)}")

    errors = []

    try:
        return _connect_with_pyodbc(
            server,
            database,
            username,
            password,
            trusted_connection,
            encrypt,
            trust_server_certificate,
        )
    except Exception as exc:
        errors.append(f"pyodbc: {exc}")

    try:
        return _connect_with_pymssql(server, database, username, password, encrypt)
    except Exception as exc:
        errors.append(f"pymssql: {exc}")

    raise RuntimeError("Database connection failed. " + " | ".join(errors))
