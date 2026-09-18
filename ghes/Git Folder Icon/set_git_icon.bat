@echo off
setlocal

if "%~1"=="" exit /b 1

set "folder=%~1"
set "ini=%folder%\desktop.ini"

if not exist "%folder%\" (
    echo Not a folder: "%folder%"
    pause
    exit /b 1
)

attrib -r -s -h "%folder%" >nul 2>&1

if exist "%ini%" (
    attrib -h -s -r "%ini%" >nul 2>&1
    del /f /q "%ini%" >nul 2>&1
)

> "%ini%" (
    echo [.ShellClassInfo]
    echo IconResource=C:\WINDOWS\System32\SHELL32.dll,85
)

attrib +h +s "%ini%"
attrib +r "%folder%"

ie4uinit.exe -ClearIconCache >nul 2>&1