from pathlib import Path
import runpy
import sys


UI_DIR = Path(__file__).resolve().parent / "UI"
if str(UI_DIR) not in sys.path:
    sys.path.insert(0, str(UI_DIR))

runpy.run_path(str(UI_DIR / "nfl_playoffs_ui.py"), run_name="__main__")
