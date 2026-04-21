import os

import streamlit as st
import requests
import pandas as pd

FASTAPI_url = os.getenv(
    "FASTAPI_URL",
    "https://mist353-api-smith-bghwaefxfefnbxdu.canadacentral-01.azurewebsites.net",
).rstrip("/")
API_REQUEST_TIMEOUT = float(os.getenv("API_REQUEST_TIMEOUT", "45"))

def fetch_data(endpoint: str, input_params: dict, method: str = "GET"):
    try:
        if method == "GET":
            response = requests.get(
                f"{FASTAPI_url}/{endpoint}",
                params=input_params,
                timeout=API_REQUEST_TIMEOUT
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
                        return None
                    return pd.DataFrame([payload])

                return pd.DataFrame()

            st.error(f"Error fetching data: {response.status_code} - {response.text}")
            return None

        st.error("Only GET method is supported right now.")
        return None

    except requests.Timeout:
        st.error(
            f"Timed out after {API_REQUEST_TIMEOUT:g} seconds waiting for the FastAPI backend."
        )
        return None
    except Exception as e:
        st.error(f"Error: {e}")
        return None
