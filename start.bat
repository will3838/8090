@echo off
setlocal
chcp 65001 >nul

set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

if not exist ".venv\Scripts\python.exe" (
    echo Виртуальное окружение не найдено. Сначала запустите setup.bat.
    pause
    exit /b 1
)

call ".venv\Scripts\activate.bat"
if errorlevel 1 (
    echo Не удалось активировать виртуальное окружение.
    pause
    exit /b 1
)

:loop
python -m bot.main
set "EXIT_CODE=%ERRORLEVEL%"

if "%EXIT_CODE%"=="0" (
    echo Бот завершился без ошибок.
    pause
    exit /b 0
)

if "%EXIT_CODE%"=="2" (
    echo BOT_TOKEN не заполнен в .env. Заполните .env и запустите start.bat снова.
    pause
    exit /b 2
)

echo Бот упал с кодом %EXIT_CODE% и будет перезапущен...
goto :loop
