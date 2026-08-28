from __future__ import annotations

"""Configuration model.

Contract:
- Read environment variables once.
- Expose typed settings to the rest of the codebase.
- This is the only module allowed to talk directly to process environment variables.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_env: str = "local"
    log_level: str = "INFO"
    database_url: str = "postgresql+psycopg://app:app@localhost:5432/claims_copilot"
    database_url_readonly: str = "postgresql://app:app@localhost:5432/claims_copilot"
    portkey_api_key: str = ""
    portkey_virtual_key: str = ""
    portkey_base_url: str = "https://api.portkey.ai/v1"
    openai_model: str = "gpt-5"
    embedding_model: str = "text-embedding-3-large"
    model_temperature: float = 0.1
    retrieval_score_threshold: float = 0.75
    injection_score_threshold: float = 0.70
    enable_hitl: bool = True

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")


settings = Settings()
