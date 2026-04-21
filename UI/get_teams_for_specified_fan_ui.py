import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    st.header("Get Teams for Specified Fan")

    fan_team_id = st.number_input("Enter FanTeamID", min_value=1, step=1)

    if st.button("Search Fan Team"):
        params = {"FanTeamID": fan_team_id}

        df = fetch_data(
            endpoint="get_teams_for_specified_fan",
            input_params=params,
            method="GET"
        )

        if df is None:
            return

        if not df.empty:
            st.success("Team found.")
            st.dataframe(df, use_container_width=True)
        else:
            st.warning("No team found for that FanTeamID.")
