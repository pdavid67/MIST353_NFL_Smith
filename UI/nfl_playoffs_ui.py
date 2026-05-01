import streamlit as st
from get_teams_by_conference_division import get_teams_by_conference_division_ui
from get_teams_in_same_conference_divison_as_specified_team_ui import get_teams_in_same_conference_division_as_specified_team_ui
from get_teams_for_specified_fan_ui import get_teams_for_specified_fan_ui
from get_teams_with_logos_for_specified_fan_ui import get_teams_with_logos_for_specified_fan_ui
from get_all_changes_made_by_specified_admin_ui import get_all_changes_made_by_specified_admin_ui
from schedule_game_ui import schedule_game_ui
from theme import apply_theme, render_app_header, render_sidebar_account
from validate_user_ui import validate_user_ui

st.set_page_config(page_title="NFL Playoffs App", page_icon="NFL", layout="wide")
apply_theme()
render_app_header()

with st.sidebar:
    st.title("NFL Tools")
    render_sidebar_account()

    api_endpoint = st.selectbox(
        "Feature",
        [
            "Validate User",
            "Schedule Game",
            "Get My Admin Changes",
            "Get Teams With Logos for Specified Fan",
            "Get Teams by Conference and Division",
            "Get Teams in Same Conference and Division as Specified Team",
            "Get Teams for Specified Fan",
        ]
    )

if api_endpoint == "Get Teams by Conference and Division":
    get_teams_by_conference_division_ui()

elif api_endpoint == "Get Teams in Same Conference and Division as Specified Team":
    get_teams_in_same_conference_division_as_specified_team_ui()

elif api_endpoint == "Get Teams for Specified Fan":
    get_teams_for_specified_fan_ui()

elif api_endpoint == "Get Teams With Logos for Specified Fan":
    get_teams_with_logos_for_specified_fan_ui()

elif api_endpoint == "Schedule Game":
    if "app_user_id" not in st.session_state:
        st.warning("Please validate as an NFLAdmin before scheduling a game.")
    elif st.session_state.get("app_user_role") != "NFLAdmin":
        st.warning("Only users with the NFLAdmin role can access Schedule Game.")
    else:
        schedule_game_ui()

elif api_endpoint == "Get My Admin Changes":
    get_all_changes_made_by_specified_admin_ui()

elif api_endpoint == "Validate User":
    validate_user_ui()
