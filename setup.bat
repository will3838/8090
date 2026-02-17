@echo off
setlocal
chcp 65001 >nul

set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

echo Проверка Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo Python не найден. Пытаемся установить через winget...
    where winget >nul 2>&1
    if errorlevel 1 (
        echo winget не найден. Установите Python 3.12 вручную: https://www.python.org/downloads/windows/
        goto :fail
    )

    winget install -e --id Python.Python.3.12
    if errorlevel 1 (
        echo Не удалось установить Python через winget. Установите Python 3.12 вручную: https://www.python.org/downloads/windows/
        goto :fail
    )

    echo Повторная проверка Python...
    python --version >nul 2>&1
    if errorlevel 1 (
        echo Python всё еще недоступен. Перезапустите setup.bat после установки Python.
        goto :fail
    )
)

if not exist ".venv\Scripts\python.exe" (
    echo Создание виртуального окружения...
    python -m venv ".venv"
    if errorlevel 1 goto :fail
)

call ".venv\Scripts\activate.bat"
if errorlevel 1 goto :fail

python -m pip install --upgrade pip
if errorlevel 1 goto :fail

pip install -r "requirements.txt"
if errorlevel 1 goto :fail

if not exist ".env" (
    copy /Y ".env.example" ".env" >nul
    if errorlevel 1 goto :fail
)

python -c "import telegram; import dotenv"
if errorlevel 1 goto :fail

echo все успешно скачанно
pause
exit /b 0

:fail
echo Возникла ошибка при настройке. Исправьте проблему и запустите setup.bat снова.
pause
exit /b 1
