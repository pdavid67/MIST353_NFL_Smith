python -m gunicorn --bind=0.0.0.0:8000 --workers 2 --worker-class uvicorn.workers.UvicornWorker --access-logfile - --error-logfile - API.nfl_playoffs_api:app
