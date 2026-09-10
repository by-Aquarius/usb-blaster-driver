@echo off
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"
echo ====================================================
echo   Altera / Intel USB-Blaster Driver 2.12.28
echo ====================================================
echo.
echo   Path: %~dp0
echo.
pnputil /add-driver "%~dp0usbblstr.inf" /install
echo.
echo   Finished. Check "Altera USB-Blaster" in Device Manager.
echo   Then run: quartus\bin64\jtagconfig.exe
echo.
pause
