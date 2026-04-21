set -e

PYTHON_TAG="$(python -c 'import sys; print(f"py{sys.version_info.major}{sys.version_info.minor}")')"
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$APP_DIR/api_packages/$PYTHON_TAG/lib/site-packages"
PORT="${PORT:-8000}"

export PYTHONPATH="$PACKAGE_DIR:$PYTHONPATH"

if python -c "import gunicorn" 2>/dev/null; then
  exec python -m gunicorn --bind=0.0.0.0:"$PORT" --workers 2 --timeout 120 --access-logfile - --error-logfile - app:application
fi

echo "gunicorn is not available; falling back to Python's built-in WSGI server."
exec python - <<'PY'
import os
from wsgiref.simple_server import make_server

from app import application

port = int(os.getenv("PORT", "8000"))

with make_server("0.0.0.0", port, application) as server:
    server.serve_forever()
PY
