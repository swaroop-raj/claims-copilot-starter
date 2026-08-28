from __future__ import annotations

"""Streamlit entrypoint.

Contract:
- Render a minimal UI that talks to the FastAPI app over HTTP.
- Own no business logic, no direct model calls, and no direct database access.
"""

import streamlit as st

st.set_page_config(page_title="Claims Copilot Starter", layout="wide")
st.title("Claims Copilot Starter")
st.write(
    "This is a UI scaffold. Start the API, wire the `/chat` endpoint, then build up from there."
)
