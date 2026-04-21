set -e

PYTHON_TAG="$(python -c 'import sys; print(f"py{sys.version_info.major}{sys.version_info.minor}")')"
APP_DIR="/home/site/wwwroot"
PACKAGE_DIR="$APP_DIR/api_packages/$PYTHON_TAG/lib/site-packages"

export PYTHONPATH="$PACKAGE_DIR:$PYTHONPATH"
exec python -m gunicorn --bind=0.0.0.0:8000 --workers 2 --timeout 120 --access-logfile - --error-logfile - app:application
