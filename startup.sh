set -e

PYTHON_TAG="$(python -c 'import sys; print(f"py{sys.version_info.major}{sys.version_info.minor}")')"
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$APP_DIR/api_packages/$PYTHON_TAG/lib/site-packages"
PORT="${PORT:-8000}"

export PYTHONPATH="$PACKAGE_DIR:$PYTHONPATH"

if python -c "import gunicorn, uvicorn" 2>/dev/null; then
  exec python -m gunicorn --bind=0.0.0.0:"$PORT" --workers 2 --worker-class uvicorn.workers.UvicornWorker --timeout 120 --access-logfile - --error-logfile - API.nfl_playoffs_api:app
fi

echo "gunicorn is not available; falling back to uvicorn."
exec python -m uvicorn API.nfl_playoffs_api:app --host 0.0.0.0 --port "$PORT"
