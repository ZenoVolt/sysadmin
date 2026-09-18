@echo off
setlocal EnableDelayedExpansion

set "GHES_PREFIX=https://ghes.a-star.edu.sg/"

cd /d "%~1" || (
    echo No folder selected.
    pause
    exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>&1 || (
    echo Not a Git repository.
    pause
    exit /b 1
)

echo Repository: %CD%
echo.

rem ------------------------------------------------------------
rem Update or repair origin
rem ------------------------------------------------------------

for /f "delims=" %%A in ('git remote get-url origin 2^>nul') do set "OLDURL=%%A"

if defined OLDURL (
    for /f "delims=" %%A in ('
        powershell -NoProfile -Command ^
          "$u='!OLDURL!'; $u -replace '^https://[^/@]+@gitlab\.(i2r|ihpc)\.a-star\.edu\.sg/', 'https://ghes.a-star.edu.sg/' -replace '^https://gitlab\.(i2r|ihpc)\.a-star\.edu\.sg/', 'https://ghes.a-star.edu.sg/'"
    ') do set "NEWURL=%%A"

    if /I "!OLDURL!"=="!NEWURL!" (
        echo   !OLDURL!

        echo !OLDURL! | findstr /I /C:"https://ghes.a-star.edu.sg/" >nul

        if not errorlevel 1 (
            echo Origin already points to GHES. Verifying...

            git ls-remote "!OLDURL!" >nul 2>&1

            if errorlevel 1 (
                echo Existing GHES origin is not valid or not accessible:
                echo   !OLDURL!
                echo.

                call :PromptForValidUrl "origin" REPAIRED_ORIGIN

                echo Updating origin...
                echo   !OLDURL!
                echo   -^> !REPAIRED_ORIGIN!

                git remote set-url origin "!REPAIRED_ORIGIN!"

                if errorlevel 1 (
                    echo Failed to repair origin.
                    pause
                    exit /b 1
                )
            ) else (
                echo Origin is valid.
            )
        ) else (
            echo Origin does not reference gitlab.i2r, gitlab.ihpc, or GHES.
        )
    ) else (
        echo Verifying target origin...
        echo   !NEWURL!

        git ls-remote "!NEWURL!" >nul 2>&1

        if errorlevel 1 (
            echo Target origin does not exist or is not accessible:
            echo   !NEWURL!
            echo.

            call :PromptForValidUrl "origin" NEWURL
        )

        echo Updating origin...
        echo   !OLDURL!
        echo   -^> !NEWURL!

        git remote set-url origin "!NEWURL!"

        if errorlevel 1 (
            echo Failed to update origin.
            pause
            exit /b 1
        )
    )
) else (
    echo No origin remote found.
)

echo.

rem ------------------------------------------------------------
rem Update .gitmodules
rem ------------------------------------------------------------

if exist ".gitmodules" (
    findstr /I /C:"gitlab.i2r.a-star.edu.sg" /C:"gitlab.ihpc.a-star.edu.sg" ".gitmodules" >nul

    if not errorlevel 1 (
        echo Verifying target submodule URLs...

        for /f "tokens=1,* delims=|" %%A in ('
            powershell -NoProfile -Command ^
              "Get-Content '.gitmodules' | ForEach-Object { if ($_ -match '^\s*url\s*=\s*(.+)$') { $old=$matches[1].Trim(); $new=$old -replace '^https://[^/@]+@gitlab\.(i2r|ihpc)\.a-star\.edu\.sg/', 'https://ghes.a-star.edu.sg/' -replace '^https://gitlab\.(i2r|ihpc)\.a-star\.edu\.sg/', 'https://ghes.a-star.edu.sg/'; if ($old -ne $new) { Write-Output ($old + '|' + $new) } } }"
        ') do (
            echo Checking %%B

            git ls-remote "%%B" >nul 2>&1

            if errorlevel 1 (
                echo Target submodule does not exist or is not accessible:
                echo   %%B
                pause
                exit /b 1
            )
        )

        echo Updating .gitmodules...

        powershell -NoProfile -ExecutionPolicy Bypass -Command ^
          "(Get-Content '.gitmodules') -replace 'https://[^/@]+@gitlab\.(i2r|ihpc)\.a-star\.edu\.sg/', 'https://ghes.a-star.edu.sg/' -replace 'https://gitlab\.(i2r|ihpc)\.a-star\.edu\.sg/', 'https://ghes.a-star.edu.sg/' | Set-Content '.gitmodules'"

        if errorlevel 1 (
            echo Failed to update .gitmodules.
            pause
            exit /b 1
        )

        echo Synchronizing submodule URLs...
        git submodule sync --recursive

        git diff --quiet -- .gitmodules

        if errorlevel 1 (
            echo.
            echo Committing .gitmodules...

            git add .gitmodules
            git commit -m "Update submodule URLs to GHES"

            if errorlevel 1 (
                echo Commit failed.
                pause
                exit /b 1
            )

            echo Pushing...
            git push

            if errorlevel 1 (
                echo Push failed.
                pause
                exit /b 1
            )

            echo Commit and push completed.
        ) else (
            echo .gitmodules already up to date.
        )
    ) else (
        echo .gitmodules does not reference gitlab.i2r or gitlab.ihpc.
    )
) else (
    echo No .gitmodules found.
)

echo.
echo Done.
pause
exit /b 0

rem ------------------------------------------------------------
rem Prompt helper
rem ------------------------------------------------------------

:PromptForValidUrl
set "PROMPT_NAME=%~1"
set "RESULT_VAR=%~2"

:PromptAgain
set "USER_URL="

echo Enter a valid GHES URL for %PROMPT_NAME%.
echo If supported by your console, the prompt will be pre-filled.
echo.

for /f "delims=" %%A in ('
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$default='https://ghes.a-star.edu.sg/'; try { Import-Module PSReadLine -ErrorAction SilentlyContinue; [Microsoft.PowerShell.PSConsoleReadLine]::Insert($default) } catch {}; Read-Host 'URL'"
') do set "USER_URL=%%A"

if not defined USER_URL (
    echo No URL entered.
    goto PromptAgain
)

echo Verifying:
echo   !USER_URL!

git ls-remote "!USER_URL!" >nul 2>&1

if errorlevel 1 (
    echo URL is not valid or not accessible:
    echo   !USER_URL!
    echo.
    goto PromptAgain
)

set "%RESULT_VAR%=!USER_URL!"
exit /b 0