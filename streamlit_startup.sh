set -e

PACKAGE_DIR="/home/site/wwwroot/.python_packages/lib/site-packages"

if [ ! -d "$PACKAGE_DIR/streamlit" ]; then
  python -m pip install --target "$PACKAGE_DIR" -r requirements.txt
fi

export PYTHONPATH="$PACKAGE_DIR:$PYTHONPATH"
python -m streamlit run UI/nfl_playoffs_ui.py --server.port 8000 --server.address 0.0.0.0 --server.headless true
