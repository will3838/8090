from __future__ import annotations

from pathlib import Path

from dotenv import load_dotenv
import os


ENV_PATH = Path(__file__).resolve().parent.parent / ".env"


def get_bot_token() -> str:
    load_dotenv(ENV_PATH)
    token = os.getenv("BOT_TOKEN", "").strip()
    if not token:
        print("BOT_TOKEN не найден. Заполните .env и запустите бота снова.")
        raise SystemExit(2)
    return token
