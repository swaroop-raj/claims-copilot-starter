from __future__ import annotations

"""Chat request and response schemas."""

from pydantic import BaseModel, Field


class ChatRequest(BaseModel):
    actor_id: str = Field(..., description="Authenticated caller id")
    claim_id: str = Field(..., description="Claim scope for the request")
    question: str = Field(..., description="Raw user question before redaction")


class Citation(BaseModel):
    chunk_id: str
    document_id: str
    source_label: str


class ChatResponse(BaseModel):
    request_id: str
    outcome: str
    answer: str
    citations: list[Citation]
    reason_code: str | None = None
