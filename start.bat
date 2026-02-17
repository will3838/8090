@echo off
chcp 65001 >nul
setlocal

set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

if not exist ".venv\Scripts\python.exe" (
    echo Виртуальное окружение не найдено. Сначала запустите setup.bat.
    pause
    exit /b 1
)

call ".venv\Scripts\activate.bat"
if not %errorlevel%==0 (
    echo Не удалось активировать виртуальное окружение.
    pause
    exit /b 1
)

:LOOP
python -m bot.main
set "EXIT_CODE=%ERRORLEVEL%"

if "%EXIT_CODE%"=="0" (
    echo Бот завершился без ошибок.
    pause
    exit /b 0
)

if "%EXIT_CODE%"=="2" (
    echo Заполните BOT_TOKEN в файле .env и запустите start.bat снова.
    pause
    exit /b 2
)

echo Бот аварийно завершился с кодом %EXIT_CODE%. Выполняется перезапуск...
goto :LOOP
