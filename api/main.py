from __future__ import annotations

"""Application entrypoint.

Contract:
- Build the FastAPI app, register middleware and routers, and expose one `app` object.
- Hold no business logic. If an endpoint behavior changes, the change belongs in
  `core/` or the router layer, not here.
"""

from fastapi import FastAPI

from api.routers import admin, chat, health, hitl

app = FastAPI(title="claims-copilot-starter", version="0.1.0")
app.include_router(health.router)
app.include_router(chat.router)
app.include_router(hitl.router)
app.include_router(admin.router)
