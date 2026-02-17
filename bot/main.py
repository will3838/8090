from __future__ import annotations

import logging
from typing import Final

from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes, MessageHandler, filters

from bot.config import get_bot_token
from bot.logging_setup import configure_logging

HELP_TEXT: Final[str] = "автор @HATE_death_ME"


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.message:
        await update.message.reply_text(HELP_TEXT)


async def text_handler(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not update.message or update.message.text is None:
        return

    if update.message.text.strip().lower() == "хелп":
        await update.message.reply_text(HELP_TEXT)


def main() -> None:
    configure_logging()
    logger = logging.getLogger(__name__)

    try:
        token = get_bot_token()

        application = Application.builder().token(token).build()
        application.add_handler(CommandHandler("help", help_command))
        application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, text_handler))

        logger.info("Бот запущен")
        application.run_polling()
        logger.info("Бот завершил работу")
    except SystemExit:
        raise
    except Exception:
        logger.exception("Критическая ошибка при работе бота")
        raise SystemExit(1)


if __name__ == "__main__":
    main()
