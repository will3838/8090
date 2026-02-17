import os
from pathlib import Path

from dotenv import load_dotenv


def get_bot_token() -> str:
    project_root = Path(__file__).resolve().parent.parent
    env_path = project_root / ".env"
    load_dotenv(env_path)

    token = (os.getenv("BOT_TOKEN") or "").strip()
    if not token:
        print("Не найден BOT_TOKEN в .env. Заполните файл .env и запустите снова.")
        raise SystemExit(2)

    return token
