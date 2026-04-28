import os

import pandas as pd
import requests
import streamlit as st

try:
    from fetch_data import FASTAPI_url
except ImportError:
    FASTAPI_url = os.getenv("FASTAPI_URL", "http://localhost:8000").strip().rstrip("/")


def schedule_game_ui():
    st.header("Schedule Game")

    home_team_id = st.number_input("Home Team ID", min_value=1, step=1, value=1)
    away_team_id = st.number_input("Away Team ID", min_value=1, step=1, value=2)
    game_round = st.text_input("Game Round", value="Wild Card")
    game_date = st.date_input("Game Date")
    game_time = st.time_input("Game Time")
    stadium_id = st.number_input("Stadium ID", min_value=1, step=1, value=1)
    nfl_admin_id = st.number_input("NFL Admin ID", min_value=1, step=1, value=5)

    if st.button("Schedule Game"):
        params = {
            "home_team_id": int(home_team_id),
            "away_team_id": int(away_team_id),
            "game_round": game_round,
            "game_date": game_date.isoformat(),
            "game_time": game_time.strftime("%H:%M:%S"),
            "stadium_id": int(stadium_id),
            "nfl_admin_id": int(nfl_admin_id),
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
