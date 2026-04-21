set -e

PACKAGE_DIR="/home/site/wwwroot/.python_packages/lib/site-packages"

export PYTHONPATH="$PACKAGE_DIR:$PYTHONPATH"
python -m streamlit run UI/nfl_playoffs_ui.py --server.port 8000 --server.address 0.0.0.0 --server.headless true
