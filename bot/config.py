from __future__ import annotations

import sys
from pathlib import Path

from dotenv import load_dotenv
import os


def get_bot_token() -> str:
    project_root = Path(__file__).resolve().parent.parent
    env_path = project_root / ".env"
    load_dotenv(env_path)

    token = (os.getenv("BOT_TOKEN") or "").strip()
    if not token:
        print(
            "Не найден BOT_TOKEN в файле .env. Заполните .env и запустите снова.",
            file=sys.stderr,
        )
        raise SystemExit(2)
    return token
