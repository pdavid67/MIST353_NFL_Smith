import streamlit as st
from fetch_data import fetch_data

def validate_user_ui():
    st.header("Validate User")

    email = st.text_input("Enter Email")
    password_hash = st.text_input("Enter Password")

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
            st.success("User validated.")
            st.dataframe(df, use_container_width=True)
        else:
            st.warning("Invalid email or password hash.")