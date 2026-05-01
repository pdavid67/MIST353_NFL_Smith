import streamlit as st
from get_teams_by_conference_division import get_teams_by_conference_division_ui
from get_teams_in_same_conference_divison_as_specified_team_ui import get_teams_in_same_conference_division_as_specified_team_ui
from get_teams_for_specified_fan_ui import get_teams_for_specified_fan_ui
from schedule_game_ui import schedule_game_ui
from validate_user_ui import validate_user_ui

st.title("NFL Playoffs App")
st.write("Welcome to the NFL Playoffs App! Use the sidebar to choose a function.")

with st.sidebar:
    st.title("NFL Playoff Functionalities")

    if "app_user_id" in st.session_state:
        st.caption(f"Signed in: {st.session_state.get('full_name', '')}")
        st.caption(f"Role: {st.session_state.get('app_user_role', '')}")
        if st.button("Sign Out"):
            for key in ("user-id", "user_id", "app_user_id", "full_name", "user_role", "app_user_role"):
                st.session_state.pop(key, None)
            st.rerun()

    api_endpoint = st.selectbox(
        "Select a functionality:",
        [
            "Get Teams by Conference and Division",
            "Get Teams in Same Conference and Division as Specified Team",
            "Get Teams for Specified Fan",
            "Schedule Game",
            "Validate User"
        ]
    )

if api_endpoint == "Get Teams by Conference and Division":
    get_teams_by_conference_division_ui()

elif api_endpoint == "Get Teams in Same Conference and Division as Specified Team":
    get_teams_in_same_conference_division_as_specified_team_ui()

elif api_endpoint == "Get Teams for Specified Fan":
    get_teams_for_specified_fan_ui()

elif api_endpoint == "Schedule Game":
    if "app_user_id" not in st.session_state:
        st.warning("Please validate as an NFLAdmin before scheduling a game.")
    elif st.session_state.get("app_user_role") != "NFLAdmin":
        st.warning("Only users with the NFLAdmin role can access Schedule Game.")
    else:
        schedule_game_ui()

elif api_endpoint == "Validate User":
    validate_user_ui()
