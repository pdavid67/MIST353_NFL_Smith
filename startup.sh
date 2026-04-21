set -e

PYTHON_TAG="$(python -c 'import sys; print(f"py{sys.version_info.major}{sys.version_info.minor}")')"
APP_DIR="/home/site/wwwroot"
PACKAGE_DIR="$APP_DIR/api_packages/$PYTHON_TAG/lib/site-packages"

export PYTHONPATH="$PACKAGE_DIR:$PYTHONPATH"

if python -c "import gunicorn" 2>/dev/null; then
  exec python -m gunicorn --bind=0.0.0.0:8000 --workers 2 --timeout 120 --access-logfile - --error-logfile - app:application
fi

echo "gunicorn is not available; falling back to Python's built-in WSGI server."
exec python - <<'PY'
from wsgiref.simple_server import make_server

from app import application

with make_server("0.0.0.0", 8000, application) as server:
    server.serve_forever()
PY
