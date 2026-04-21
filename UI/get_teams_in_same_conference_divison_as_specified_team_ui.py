#get_teams_in_same_conference_division_as_specified_team_ui.py
import streamlit as st
from fetch_data import fetch_data

def get_teams_in_same_conference_division_as_specified_team_ui():
    st.title("Get Teams in Same Conference and Division")

    teams = [
        "Baltimore Ravens",
        "Cincinnati Bengals",
        "Cleveland Browns",
        "Pittsburgh Steelers",

        "Buffalo Bills",
        "Miami Dolphins",
        "New England Patriots",
        "New York Jets",

        "Houston Texans",
        "Indianapolis Colts",
        "Jacksonville Jaguars",
        "Tennessee Titans",

        "Denver Broncos",
        "Kansas City Chiefs",
        "Las Vegas Raiders",
        "Los Angeles Chargers",

        "Chicago Bears",
        "Detroit Lions",
        "Green Bay Packers",
        "Minnesota Vikings",

        "Dallas Cowboys",
        "New York Giants",
        "Philadelphia Eagles",
        "Washington Commanders",

        "Atlanta Falcons",
        "Carolina Panthers",
        "New Orleans Saints",
        "Tampa Bay Buccaneers",

        "Arizona Cardinals",
        "Los Angeles Rams",
        "San Francisco 49ers",
        "Seattle Seahawks"
    ]

    team_name = st.selectbox("Select Team", teams)

    if st.button("Fetch Teams"):
        input_params = {"team_name": team_name.strip()}

        df = fetch_data("get_teams_in_same_conference_division_as_specified_team", input_params)

        if df is not None and not df.empty:
            st.success(f"Found {len(df)} teams in the same division")
            st.subheader(f"Teams in the same conference and division as {team_name}:")
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info(f"No teams found in the same conference and division as {team_name}.")