---
description: Streamlit UI conventions.
paths:
  - "app/**"
---

# Streamlit conventions

- The UI is a client. It talks to FastAPI over HTTP and owns no business logic.
  If you are tempted to import from `core/` inside `app/`, stop.
- `app/main.py` is layout and routing only. Widgets live in `app/components/`.
- All session state keys are declared in `app/state/keys.py`. No string literals for
  state keys scattered through the UI.
- Stream responses token by token. A blocking spinner on a grounded RAG call feels broken.
- Citations render as expandable source cards, not footnote noise in the prose.
- When the API returns an escalation, the UI says so plainly and shows the reason code.
  Never fake an answer to fill the space.
- Show the `request_id` in the UI. It is how you correlate to the audit trail when
  something looks wrong.
- No secrets in `st.secrets` for this project. The UI holds no model credentials, ever.
- Keep reruns cheap: cache API clients with `st.cache_resource`, never cache responses
  that contain claim data.
