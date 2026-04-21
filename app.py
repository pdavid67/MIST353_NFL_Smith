import traceback
import sys
import subprocess
from pathlib import Path


APP_DIR = Path(__file__).resolve().parent
PYTHON_TAG = f"py{sys.version_info.major}{sys.version_info.minor}"
PACKAGE_DIR = APP_DIR / "api_packages" / PYTHON_TAG / "lib" / "site-packages"
REQUIREMENTS_PATH = APP_DIR / "API" / "requirements.txt"


def _add_package_dir():
    if PACKAGE_DIR.exists():
        package_path = str(PACKAGE_DIR)
        if package_path not in sys.path:
            sys.path.insert(0, package_path)


def _ensure_runtime_packages():
    _add_package_dir()
    try:
        import a2wsgi  # noqa: F401
        import fastapi  # noqa: F401
    except Exception:
        PACKAGE_DIR.mkdir(parents=True, exist_ok=True)
        subprocess.check_call(
            [
                sys.executable,
                "-m",
                "pip",
                "install",
                "--target",
                str(PACKAGE_DIR),
                "-r",
                str(REQUIREMENTS_PATH),
            ]
        )
        _add_package_dir()


_ensure_runtime_packages()


def _startup_error_app(startup_error: str):
    error_body = startup_error.encode("utf-8", errors="replace")

    def _app(environ, start_response):
        start_response(
            "500 Internal Server Error",
            [
                ("Content-Type", "text/plain; charset=utf-8"),
                ("Content-Length", str(len(error_body))),
            ],
        )
        return [error_body]

    return _app


try:
    from a2wsgi import ASGIMiddleware

    from API.nfl_playoffs_api import app as fastapi_app

    # Azure App Service's default Python startup expects a WSGI app.
    # Wrap the FastAPI ASGI app so publish-profile deployments boot correctly.
    asgi_app = fastapi_app
    app = ASGIMiddleware(asgi_app)
except Exception:
    app = _startup_error_app(traceback.format_exc())

application = app
