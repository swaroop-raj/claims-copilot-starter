from __future__ import annotations

"""Human-in-the-loop routes.

Contract:
- Expose pending reviews and allow a reviewer decision to be submitted.
- Review state belongs in `core/hitl/`, not in the router.
"""

from fastapi import APIRouter

router = APIRouter(prefix="/hitl", tags=["hitl"])


@router.get("/queue")
async def get_queue() -> dict[str, list[dict[str, str]]]:
    return {"items": []}


@router.post("/{review_id}/decide")
async def decide(review_id: str) -> dict[str, str]:
    return {"review_id": review_id, "status": "not_implemented"}
