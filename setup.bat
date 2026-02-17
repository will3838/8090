@echo off
chcp 65001 >nul
setlocal

set "PROJECT_DIR=%~dp0"
cd /d "%PROJECT_DIR%"

echo [1/7] Проверка Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo Python не найден. Пытаемся установить через winget...
    winget --version >nul 2>&1
    if errorlevel 1 (
        echo winget не найден. Установите Python 3.12 вручную и запустите setup.bat снова.
        goto :end
    )

    winget install -e --id Python.Python.3.12
    if errorlevel 1 (
        echo Не удалось установить Python через winget. Установите Python 3.12 вручную и запустите setup.bat снова.
        goto :end
    )

    python --version >nul 2>&1
    if errorlevel 1 (
        echo Python все еще недоступен. Закройте окно, откройте новый терминал и запустите setup.bat снова.
        goto :end
    )
)

echo [2/7] Создание виртуального окружения...
if not exist ".venv\Scripts\python.exe" (
    python -m venv ".venv"
    if errorlevel 1 (
        echo Ошибка при создании .venv
        goto :end
    )
)

echo [3/7] Активация .venv...
call ".venv\Scripts\activate.bat"
if errorlevel 1 (
    echo Не удалось активировать виртуальное окружение.
    goto :end
)

echo [4/7] Обновление pip...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo Не удалось обновить pip.
    goto :end
)

echo [5/7] Установка зависимостей...
pip install -r "requirements.txt"
if errorlevel 1 (
    echo Не удалось установить зависимости.
    goto :end
)

echo [6/7] Подготовка .env...
if not exist ".env" (
    copy /Y ".env.example" ".env" >nul
    if errorlevel 1 (
        echo Не удалось создать .env из .env.example.
        goto :end
    )
)

echo [7/7] Проверка импортов...
python -c "import telegram; import dotenv"
if errorlevel 1 (
    echo Проверка импортов не пройдена.
    goto :end
)

echo все успешно скачанно

:end
pause
endlocal
