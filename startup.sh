set -e

PACKAGE_DIR="/home/site/wwwroot/api_packages/lib/site-packages"

export PYTHONPATH="$PACKAGE_DIR:$PYTHONPATH"
exec python -m gunicorn --bind=0.0.0.0:8000 --workers 2 --worker-class uvicorn.workers.UvicornWorker --timeout 120 --access-logfile - --error-logfile - API.nfl_playoffs_api:app
