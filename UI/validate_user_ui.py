import streamlit as st
from fetch_data import fetch_data

def validate_user_ui():
    st.header("Validate User")

    email = st.text_input("Enter Email")
    password_hash = st.text_input("Enter Password Hash", type="password")

    if st.button("Validate User"):
        params = {
            "email": email,
            "password_hash": password_hash
        }

        df = fetch_data(
            endpoint="validate_user",
            input_params=params,
            method="GET"
        )

        if df is not None and not df.empty:
            user = df.iloc[0]
            validated_user_id = int(user["AppUserID"])
            st.session_state["user-id"] = validated_user_id
            st.session_state["user_id"] = validated_user_id
            st.session_state["full_name"] = user["FullName"]
            st.session_state["user_role"] = user["UserRole"]
            st.success("User validated.")
            st.dataframe(df, use_container_width=True)
        else:
            st.session_state.pop("user-id", None)
            st.session_state.pop("user_id", None)
            st.session_state.pop("full_name", None)
            st.session_state.pop("user_role", None)
            st.warning("Invalid email or password hash.")
