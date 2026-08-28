from __future__ import annotations

"""Starter E2E test for the stub chat route."""

from fastapi.testclient import TestClient

from api.main import app


def test_chat_route_returns_scaffold_message() -> None:
    client = TestClient(app)
    response = client.post(
        "/chat",
        json={"actor_id": "user-1", "claim_id": "CLM-0001", "question": "What happened?"},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["outcome"] == "escalated"
    assert body["reason_code"] == "not_implemented"
