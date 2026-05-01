import streamlit as st

from fetch_data import fetch_data


def get_all_changes_made_by_specified_admin_ui():
    st.header("Admin Changes")

    user_id = st.session_state.get("app_user_id") or st.session_state.get("user_id")
    user_role = st.session_state.get("app_user_role") or st.session_state.get("user_role")

    if user_id is None:
        st.warning("Please validate as an NFLAdmin first.")
        return

    if user_role != "NFLAdmin":
        st.warning("Only users with the NFLAdmin role can view admin changes.")
        return

    st.write(f"Showing changes made by {st.session_state.get('full_name', 'current admin')}.")

    df = fetch_data(
        endpoint="get_all_changes_made_by_specified_admin",
        input_params={"user_id": user_id},
        method="GET",
    )

    if df is not None and not df.empty:
        st.dataframe(df, width="stretch")
    else:
        st.info("No changes found for this admin.")
