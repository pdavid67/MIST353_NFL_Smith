from a2wsgi import ASGIMiddleware

from API.nfl_playoffs_api import app as fastapi_app

# Azure App Service's default Python startup expects a WSGI app.
# Wrap the FastAPI ASGI app so publish-profile deployments boot correctly.
asgi_app = fastapi_app
app = ASGIMiddleware(asgi_app)
