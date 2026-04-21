import streamlit as st
from fetch_data import fetch_data

def get_teams_by_conference_division_ui():
    st.header("Get Teams by Conference and Division")

    conference = st.selectbox("Select Conference", ["AFC", "NFC"])
    division = st.selectbox("Select Division", ["East", "North", "South", "West"])

    if st.button("Fetch Conference/Division Teams"):
        params = {
            "conference": conference,
            "division": division
        }

        df = fetch_data("get_teams_by_conference_division", params)

        if df is None:
            return

        if df.empty:
            st.info(f"No teams found for {conference} {division}.")
        else:
            st.dataframe(df, use_container_width=True)
