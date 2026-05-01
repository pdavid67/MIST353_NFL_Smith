import base64

import pandas as pd
import streamlit as st

from fetch_data import fetch_data


def get_teams_with_logos_for_specified_fan_ui():
    st.header("My Teams With Logos")

    user_id = st.session_state.get("app_user_id") or st.session_state.get("user_id")
    user_role = st.session_state.get("app_user_role") or st.session_state.get("user_role")

    if user_id is None:
        st.warning("Please validate your user first.")
        return

    if user_role != "NFLFan":
        st.warning("Team logo favorites are available for NFLFan users.")
        return

    df = fetch_data(
        endpoint="get_teams_with_logos_for_specified_fan",
        input_params={"fan_id": user_id},
        method="GET",
    )

    if df is None or df.empty:
        st.info("No teams found for this fan.")
        return

    st.write(f"Showing teams followed by {st.session_state.get('full_name', 'current fan')}.")

    header = st.columns([1, 3, 2, 3, 1])
    header[0].write("**Logo**")
    header[1].write("**Team**")
    header[2].write("**Conference / Division**")
    header[3].write("**Colors**")
    header[4].write("**Primary**")
    st.divider()

    for row in df.to_dict("records"):
        cols = st.columns([1, 3, 2, 3, 1])
        logo = row.get("TeamLogo")
        if isinstance(logo, str) and logo and pd.notna(logo):
            cols[0].image(base64.b64decode(logo), width=64)
        else:
            cols[0].caption("No logo")
        cols[1].write(row.get("TeamName", ""))
        cols[2].write(f"{row.get('Conference', '')} / {row.get('Division', '')}")
        cols[3].write(row.get("TeamColors", ""))
        cols[4].write("Yes" if row.get("PrimaryTeam") else "")
        st.divider()
