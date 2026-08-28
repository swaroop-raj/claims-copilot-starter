from __future__ import annotations

"""Chat route.

Contract:
- Accept a redaction-safe chat request.
- Orchestrate: redact -> authorize -> injection check -> retrieve -> generate -> verify citations.
- Return either a cited answer or an escalation decision.
"""

from fastapi import APIRouter

from api.schemas.chat import ChatRequest, ChatResponse

router = APIRouter(tags=["chat"])


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    return ChatResponse(
        request_id="stub-request-id",
        outcome="escalated",
        answer="Starter scaffold only. Implement the pipeline in core/.",
        citations=[],
        reason_code="not_implemented",
    )
