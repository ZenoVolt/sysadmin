@echo off
setlocal

rem Set working directory to this script's folder
cd /d "%~dp0"

set "SENDTO=%APPDATA%\Microsoft\Windows\SendTo"

copy /Y "git_switch_ghes.bat" "%SENDTO%\git_switch_ghes.bat" >nul

if errorlevel 1 (
    echo Failed to copy git_switch_ghes.bat to the SendTo folder.
) else (
    echo Installed successfully.
    echo.
    echo You can now right-click a folder and choose:
    echo Send to ^> git_switch_ghes
)

pause