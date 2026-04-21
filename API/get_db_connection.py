import os
from importlib import import_module
from pathlib import Path

try:
    from dotenv import load_dotenv
except ImportError:
    def load_dotenv(*_args, **_kwargs):
        return None

ENV_PATH = Path(__file__).resolve().with_name(".env")
load_dotenv(dotenv_path=ENV_PATH)


def _parse_sql_server(server: str) -> tuple[str, str]:
    normalized_server = server.strip()
    if normalized_server.lower().startswith("tcp:"):
        normalized_server = normalized_server[4:]

    host, separator, port = normalized_server.partition(",")
    return host.strip(), port.strip() if separator else "1433"


def _connect_with_pyodbc(server: str, database: str, username: str, password: str):
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
            return pyodbc.connect(connection_string, timeout=8)
        except pyodbc.Error as exc:
            last_error = exc

    raise RuntimeError(f"Database connection failed with pyodbc: {last_error}")


def _connect_with_pymssql(server: str, database: str, username: str, password: str):
    pymssql = import_module("pymssql")
    host, port = _parse_sql_server(server)

    return pymssql.connect(
        server=host,
        user=username,
        password=password,
        database=database,
        port=port,
        login_timeout=8,
        timeout=15,
        tds_version="7.4",
        encryption="require",
    )


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

    errors = []

    for connector_name, connector in (
        ("pymssql", _connect_with_pymssql),
    ):
        try:
            return connector(server, database, username, password)
        except Exception as exc:
            errors.append(f"{connector_name}: {exc}")

    raise RuntimeError("Database connection failed. " + " | ".join(errors))
