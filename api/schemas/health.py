from __future__ import annotations

"""Health response schema."""

from pydantic import BaseModel


class HealthResponse(BaseModel):
    status: str
    database: str
    portkey: str
