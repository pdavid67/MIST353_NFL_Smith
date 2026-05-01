from pathlib import Path
import sys


PROJECT_ROOT = Path(__file__).resolve().parents[1]
API_DIR = PROJECT_ROOT / "API"
if str(API_DIR) not in sys.path:
    sys.path.insert(0, str(API_DIR))

from get_db_connection import get_db_connection


LOGO_DIR = Path(__file__).resolve().parent / "TeamLogos"
TEAMS = [
    "Baltimore Ravens",
    "Cincinnati Bengals",
    "Cleveland Browns",
    "New England Patriots",
    "Pittsburgh Steelers",
    "Tampa Bay Buccaneers",
]


def insert_logos():
    conn = get_db_connection()
    cursor = conn.cursor()

    for team in TEAMS:
        logo_path = LOGO_DIR / f"{team.replace(' ', '_')}.png"
        logo_data = logo_path.read_bytes()
        cursor.execute(
            "UPDATE Team SET TeamLogo = ? WHERE TeamName = ?",
            (logo_data, team),
        )

    conn.commit()
    conn.close()


if __name__ == "__main__":
    insert_logos()
