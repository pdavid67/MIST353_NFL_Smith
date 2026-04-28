import os

import pandas as pd
import requests
import streamlit as st

try:
    from fetch_data import FASTAPI_url
except ImportError:
    FASTAPI_url = os.getenv("FASTAPI_URL", "http://localhost:8000").strip().rstrip("/")


def schedule_game_ui():
    st.header("Schedule a Game")

    home_team_id = st.text_input("Enter Home Team ID:", value="4")
    away_team_id = st.text_input("Enter Away Team ID:", value="5")
    game_round = st.text_input("Enter Game Round (e.g., Regular Season, Playoff):", value="Wild Card")
    game_date = st.text_input("Enter Game Date (YYYY-MM-DD):", value="2026-05-31")
    game_time = st.text_input("Enter Game Time (HH:MM:SS):", value="15:00")
    stadium_id = st.text_input("Enter Stadium ID:", value="1")
    nfl_admin_id = st.text_input("Enter NFL Admin ID:", value="5")

    if st.button("Schedule Game"):
        params = {
            "home_team_id": int(home_team_id.strip()),
            "away_team_id": int(away_team_id.strip()),
            "game_round": game_round,
            "game_date": game_date.strip(),
            "game_time": game_time.strip(),
            "stadium_id": int(stadium_id.strip()),
            "nfl_admin_id": int(nfl_admin_id.strip()),
        }

        try:
            response = requests.post(
                f"{FASTAPI_url}/schedule_game/",
                params=params,
                timeout=10,
            )

            if response.status_code != 200:
                st.error(f"Error scheduling game: {response.status_code} - {response.text}")
                return

            payload = response.json()
            if "error" in payload:
                st.error(payload["error"])
                return

            st.success(payload.get("message", "Game scheduled successfully."))

            data = payload.get("data", [])
            if data:
                st.dataframe(pd.DataFrame(data), use_container_width=True)
        except Exception as e:
            st.error(f"Error: {e}")
