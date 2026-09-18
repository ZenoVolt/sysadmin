@echo off
setlocal

rem Set working directory to this script's folder
cd /d "%~dp0"

set "SENDTO=%APPDATA%\Microsoft\Windows\SendTo"

copy /Y "set_git_icon.bat" "%SENDTO%\set_git_icon.bat" >nul

if errorlevel 1 (
    echo Failed to copy set_git_icon.bat to the SendTo folder.
) else (
    echo Installed successfully.
    echo.
    echo You can now right-click a folder and choose:
    echo Send to ^> set_git_icon
)

pause