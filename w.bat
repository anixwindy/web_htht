@echo off
chcp 65001 >nul
cd /d "%~dp0"
title world_log

:menu
cls
echo ==========================================================
echo   world_log          https://segv0x41.com
echo ==========================================================
echo.
echo    [1]   write     - new post (create file + open editor)
echo    [2]   rebuild   - posts.json only, nothing goes public
echo    [3]   publish   - rebuild posts.json, then commit + push
echo    [Q]   quit
echo.
echo ----------------------------------------------------------
choice /c 123Q /n /m "  select [1/2/3/Q]: "

REM choice returns 1..4 ; errorlevel checks MUST be descending
if errorlevel 4 goto :end
if errorlevel 3 goto :publish
if errorlevel 2 goto :rebuild
if errorlevel 1 goto :write
goto :end

:write
echo.
echo ---- write ----------------------------------------------
call "%~dp0new_post.bat"
goto :menu

:rebuild
echo.
echo ---- rebuild --------------------------------------------
call "%~dp0gen_posts.bat"
goto :menu

:publish
echo.
echo ---- publish --------------------------------------------
call "%~dp0push.bat"
goto :menu

:end
echo.
echo   bye.
echo.
