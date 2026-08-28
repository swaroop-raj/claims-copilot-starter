from __future__ import annotations

"""Health route.

Contract:
- Return process status plus dependency reachability for the database and Portkey.
- Never leak secrets or raw exception messages in the response.
"""

from fastapi import APIRouter

from api.schemas.health import HealthResponse

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthResponse)
async def get_health() -> HealthResponse:
    return HealthResponse(status="ok", database="unknown", portkey="unknown")
