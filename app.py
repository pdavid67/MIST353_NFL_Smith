import traceback
import sys
from pathlib import Path


PACKAGE_DIR = Path(__file__).resolve().parent / "api_packages" / "lib" / "site-packages"
if PACKAGE_DIR.exists():
    sys.path.insert(0, str(PACKAGE_DIR))


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
