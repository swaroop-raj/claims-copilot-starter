from __future__ import annotations

"""Admin routes.

Contract:
- Surface audit data keyed by request id.
- Never expose raw prompt or claim content from the audit trail.
"""

from fastapi import APIRouter

router = APIRouter(prefix="/admin", tags=["admin"])


@router.get("/audit/{request_id}")
async def get_audit(request_id: str) -> dict[str, object]:
    return {"request_id": request_id, "events": []}
