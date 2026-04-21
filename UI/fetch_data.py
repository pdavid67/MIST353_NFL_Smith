import streamlit as st
import requests
import pandas as pd
import os

def _get_fastapi_url() -> str:
    env_url = os.getenv("FASTAPI_URL")
    if env_url:
        return env_url.rstrip("/")

    try:
        return st.secrets.get("FASTAPI_URL", "http://localhost:8000").rstrip("/")
    except Exception:
        return "http://localhost:8000"


FASTAPI_url = _get_fastapi_url()

def fetch_data(endpoint: str, input_params: dict, method: str = "GET"):
    try:
        if method == "GET":
            response = requests.get(
                f"{FASTAPI_url}/{endpoint}",
                params=input_params,
                timeout=10
            )

            if response.status_code == 200:
                payload = response.json()

                if isinstance(payload, list):
                    return pd.DataFrame(payload)

                if isinstance(payload, dict):
                    if "data" in payload:
                        return pd.DataFrame(payload["data"])
                    if "error" in payload:
                        st.error(payload["error"])
                        return pd.DataFrame()
                    return pd.DataFrame([payload])

                return pd.DataFrame()

            st.error(f"Error fetching data: {response.status_code} - {response.text}")
            return pd.DataFrame()

        st.error("Only GET method is supported right now.")
        return pd.DataFrame()

    except Exception as e:
        st.error(f"Error: {e}")
        return pd.DataFrame()
