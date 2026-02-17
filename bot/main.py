import logging

from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes, MessageHandler, filters

from bot.config import get_bot_token
from bot.logging_setup import configure_logging

HELP_TEXT = "автор @HATE_death_ME"


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.message:
        await update.message.reply_text(HELP_TEXT)


async def handle_text(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not update.message or update.message.text is None:
        return

    if update.message.text.strip().lower() == "хелп":
        await update.message.reply_text(HELP_TEXT)


def main() -> None:
    log_path = configure_logging()
    logging.info("Логирование инициализировано. Лог-файл: %s", log_path)

    token = get_bot_token()

    application = Application.builder().token(token).build()
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_text))

    logging.info("Бот запускается в режиме polling")
    application.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception:
        logging.exception("Критическая ошибка при работе бота")
        raise SystemExit(1)
