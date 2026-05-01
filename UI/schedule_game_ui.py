from datetime import date

import pandas as pd
import requests
import streamlit as st

from fetch_data import FASTAPI_url, fetch_data


def _get_logged_in_admin_id():
    role = st.session_state.get("app_user_role") or st.session_state.get("user_role")
    if role != "NFLAdmin":
        return None
    return st.session_state.get("app_user_id") or st.session_state.get("user_id")


def _name_to_id_options(df: pd.DataFrame, id_column: str, name_column: str):
    if df is None or df.empty:
        return {}
    return {
        str(row[name_column]): int(row[id_column])
        for _, row in df.sort_values(name_column).iterrows()
    }


def schedule_game_ui():
    st.header("Schedule a Game")

    nfl_admin_id = _get_logged_in_admin_id()
    if nfl_admin_id is None:
        st.warning("Please validate as an NFLAdmin before scheduling a game.")
        return

    teams_df = fetch_data("get_all_teams", {})
    stadiums_df = fetch_data("get_all_stadiums", {})
    team_options = _name_to_id_options(teams_df, "TeamID", "TeamName")
    stadium_options = _name_to_id_options(stadiums_df, "StadiumID", "StadiumName")

    if not team_options or not stadium_options:
        st.warning("Teams and stadiums must load before a game can be scheduled.")
        return

    team_names = list(team_options.keys())
    home_team_name = st.selectbox("Select Home Team", team_names)
    away_team_name = st.selectbox(
        "Select Away Team",
        team_names,
        index=1 if len(team_names) > 1 else 0,
    )
    stadium_name = st.selectbox("Select Stadium", list(stadium_options.keys()))
    game_round = st.selectbox(
        "Select Game Round",
        ["Wild Card", "Divisional", "Conference Championship", "Super Bowl"],
    )
    game_date = st.date_input("Select Game Date", value=date(2026, 6, 30))
    game_time = st.selectbox(
        "Select Game Start Time",
        ["13:00:00", "16:30:00", "20:15:00"],
    )

    if st.button("Schedule Game"):
        if home_team_name == away_team_name:
            st.error("Home team and away team must be different.")
            return

        params = {
            "home_team_id": team_options[home_team_name],
            "away_team_id": team_options[away_team_name],
            "game_round": game_round,
            "game_date": game_date.isoformat(),
            "game_time": game_time,
            "stadium_id": stadium_options[stadium_name],
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

            message = payload.get("message", "Game scheduled successfully.")
            if "already scheduled" in message.lower():
                st.info(message)
            else:
                st.success(message)

            data = payload.get("data", [])
            if data:
                st.dataframe(pd.DataFrame(data), use_container_width=True)
        except Exception as e:
            st.error(f"Error: {e}")
