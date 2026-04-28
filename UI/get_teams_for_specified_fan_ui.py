import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    st.header("Get Teams for Specified Fan")

    user_id = st.session_state.get("user-id") or st.session_state.get("user_id")

    if user_id is None:
        st.warning("Please validate your user first.")
        return

    st.write(f"Showing teams followed by {st.session_state.get('full_name', 'current user')}.")

    if st.button("Search My Teams"):
        params = {"user_id": user_id}

        df = fetch_data(
            endpoint="get_teams_for_specified_fan",
            input_params=params,
            method="GET"
        )

        if df is not None and not df.empty:
            st.success("Teams found.")
            st.dataframe(df, use_container_width=True)
        else:
            st.warning("No teams found for this user.")
