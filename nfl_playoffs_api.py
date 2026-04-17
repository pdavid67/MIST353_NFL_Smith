from pathlib import Path
import sys


API_DIR = Path(__file__).resolve().parent / "API"
if str(API_DIR) not in sys.path:
    sys.path.insert(0, str(API_DIR))

from API.nfl_playoffs_api import app
