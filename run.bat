@echo off
rem Start SysMaid on Windows. Double-click this file or run it from a terminal.
rem On the first run it installs the bundled Python + GTK environment if missing.
setlocal
cd /d "%~dp0"

set "PY=%~dp0vcpkg_installed\x86-windows\tools\python3\python.exe"

if not exist "%PY%" (
    echo Python/GTK environment not found. Installing it now ^(one time, needs internet^)...
    powershell -NoProfile -ExecutionPolicy Bypass -File "windows\python-gtk3-install.ps1"
    if not exist "%PY%" (
        echo.
        echo Setup failed: "%PY%" was not created.
        pause
        exit /b 1
    )
)

rem Install Python dependencies if any are missing.
"%PY%" -c "import psutil, requests, win32api" >nul 2>&1
if errorlevel 1 (
    echo Installing Python dependencies...
    "%PY%" -m pip install --disable-pip-version-check -r windows\requirements.txt
)

"%PY%" bleachbit.py %*
if errorlevel 1 (
    echo.
    echo SysMaid exited with an error.
    pause
)
endlocal
