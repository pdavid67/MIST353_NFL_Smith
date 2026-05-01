import streamlit as st


SESSION_KEYS = ("user-id", "user_id", "app_user_id", "full_name", "user_role", "app_user_role")


def apply_theme():
    st.markdown(
        """
        <style>
            :root {
                --page-bg: #0f141d;
                --panel-bg: #151b26;
                --panel-soft: #1d2633;
                --line: rgba(255, 255, 255, 0.10);
                --text: #f8fafc;
                --muted: #aab4c3;
                --accent: #d71920;
                --accent-strong: #b5121b;
                --success-bg: rgba(46, 160, 67, 0.22);
            }

            .stApp {
                background:
                    radial-gradient(circle at top left, rgba(215, 25, 32, 0.15), transparent 34rem),
                    linear-gradient(135deg, #101722 0%, #0f141d 52%, #111827 100%);
                color: var(--text);
            }

            .block-container {
                max-width: 1180px;
                padding-top: 2rem;
                padding-bottom: 4rem;
            }

            [data-testid="stSidebar"] {
                background: #111827;
                border-right: 1px solid var(--line);
            }

            [data-testid="stSidebar"] h1,
            [data-testid="stSidebar"] h2,
            [data-testid="stSidebar"] h3,
            [data-testid="stSidebar"] label {
                color: var(--text);
            }

            h1, h2, h3 {
                color: var(--text);
                letter-spacing: 0;
            }

            p, label, span {
                color: inherit;
            }

            div[data-testid="stSelectbox"] > label,
            div[data-testid="stTextInput"] > label,
            div[data-testid="stDateInput"] > label {
                font-weight: 700;
                color: var(--text);
            }

            .stButton > button {
                background: var(--accent);
                color: white;
                border: 0;
                border-radius: 8px;
                min-height: 2.75rem;
                font-weight: 800;
                padding-left: 1.15rem;
                padding-right: 1.15rem;
            }

            .stButton > button:hover {
                background: var(--accent-strong);
                color: white;
                border: 0;
            }

            div[data-testid="stAlert"] {
                border-radius: 8px;
                border: 1px solid var(--line);
            }

            div[data-testid="stDataFrame"] {
                border-radius: 8px;
                overflow: hidden;
                border: 1px solid var(--line);
            }

            .app-header {
                padding: 0.75rem 0 1.35rem 0;
                border-bottom: 1px solid var(--line);
                margin-bottom: 1.75rem;
            }

            .app-title {
                font-size: 2.85rem;
                line-height: 1.05;
                font-weight: 900;
                color: var(--text);
                margin: 0 0 0.75rem 0;
            }

            .app-welcome {
                font-size: 1.1rem;
                color: var(--muted);
                margin: 0;
            }

            .account-card {
                background: var(--panel-soft);
                border: 1px solid var(--line);
                border-radius: 8px;
                padding: 0.85rem;
                margin: 0.75rem 0 1rem 0;
            }

            .account-name {
                font-weight: 800;
                color: var(--text);
                margin-bottom: 0.2rem;
            }

            .role-pill {
                display: inline-block;
                background: rgba(34, 197, 94, 0.18);
                color: #9df2b5;
                border: 1px solid rgba(34, 197, 94, 0.32);
                border-radius: 999px;
                padding: 0.15rem 0.55rem;
                font-size: 0.8rem;
                font-weight: 800;
            }

            .section-panel {
                background: rgba(21, 27, 38, 0.72);
                border: 1px solid var(--line);
                border-radius: 8px;
                padding: 1.25rem;
                margin-top: 0.75rem;
            }

            .success-strip {
                background: var(--success-bg);
                border: 1px solid rgba(46, 160, 67, 0.36);
                color: #b7f7c3;
                border-radius: 8px;
                padding: 0.8rem 1rem;
                font-weight: 800;
                margin: 0.75rem 0 1.25rem 0;
            }

            .muted-note {
                color: var(--muted);
                font-weight: 700;
                margin: 0.35rem 0 0.75rem 0;
            }
        </style>
        """,
        unsafe_allow_html=True,
    )


def render_app_header():
    full_name = st.session_state.get("full_name")
    if full_name:
        welcome = f"Welcome, {full_name}."
    else:
        welcome = "Welcome to the NFL Playoffs App."

    st.markdown(
        f"""
        <div class="app-header">
            <div class="app-title">NFL Playoffs App</div>
            <p class="app-welcome">{welcome}</p>
        </div>
        """,
        unsafe_allow_html=True,
    )


def render_sidebar_account():
    if "app_user_id" not in st.session_state:
        st.caption("Not signed in")
        return

    full_name = st.session_state.get("full_name", "Signed in user")
    user_role = st.session_state.get("app_user_role", "")
    st.markdown(
        f"""
        <div class="account-card">
            <div class="account-name">{full_name}</div>
            <span class="role-pill">{user_role}</span>
        </div>
        """,
        unsafe_allow_html=True,
    )

    if st.button("Sign Out", use_container_width=True):
        for key in SESSION_KEYS:
            st.session_state.pop(key, None)
        st.rerun()
