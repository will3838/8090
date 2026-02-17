@echo off
chcp 65001 >nul
setlocal

set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

where python >nul 2>&1
if %errorlevel%==0 goto :PYTHON_READY

echo Python не найден. Пытаемся установить через winget...
where winget >nul 2>&1
if not %errorlevel%==0 (
    echo winget не найден. Установите Python 3.12 вручную с https://www.python.org/downloads/windows/
    goto :FAIL
)

winget install -e --id Python.Python.3.12
if not %errorlevel%==0 (
    echo Не удалось установить Python через winget. Установите Python 3.12 вручную с https://www.python.org/downloads/windows/
    goto :FAIL
)

:PYTHON_READY
python --version >nul 2>&1
if not %errorlevel%==0 (
    echo Python по-прежнему недоступен в PATH. Перезапустите терминал или установите Python вручную.
    goto :FAIL
)

if not exist ".venv\Scripts\python.exe" (
    python -m venv ".venv"
    if not %errorlevel%==0 goto :FAIL
)

call ".venv\Scripts\activate.bat"
if not %errorlevel%==0 goto :FAIL

python -m pip install --upgrade pip
if not %errorlevel%==0 goto :FAIL

pip install -r "requirements.txt"
if not %errorlevel%==0 goto :FAIL

if not exist ".env" (
    copy /Y ".env.example" ".env" >nul
    if not %errorlevel%==0 goto :FAIL
)

python -c "import telegram; import dotenv"
if not %errorlevel%==0 goto :FAIL

echo все успешно скачанно
pause
exit /b 0

:FAIL
echo Произошла ошибка. Исправьте её и запустите setup.bat снова.
pause
exit /b 1
