@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ==========================================================
echo   world_log  publish
echo ==========================================================
echo.

REM ---- 1. rebuild posts.json -------------------------------
echo [1/4] rebuilding posts.json ...
py "%~dp0gen_posts.py"
if errorlevel 1 (
  echo.
  echo [ERROR] gen_posts.py failed. Nothing was pushed.
  pause
  exit /b 1
)
echo.

REM ---- 2. anything to publish? ------------------------------
echo [2/4] checking for changes ...
git status --porcelain | findstr /r "." >nul
if errorlevel 1 (
  echo.
  echo   No changes. Site is already up to date.
  echo.
  pause
  exit /b 0
)

echo.
echo ----------------------------------------------------------
echo   THESE FILES WILL GO PUBLIC:
echo ----------------------------------------------------------
git status --short
echo ----------------------------------------------------------
echo.

REM ---- 3. commit -------------------------------------------
echo [3/4] commit
echo   ^(press Ctrl+C now to abort^)
set "MSG="
set /p "MSG=  message (blank = auto): "
if not defined MSG set "MSG=log: update %DATE%"

git add -A
git commit -m "%MSG%"
if errorlevel 1 (
  echo.
  echo [ERROR] commit failed.
  pause
  exit /b 1
)
echo.

REM ---- 4. push ---------------------------------------------
echo [4/4] pushing to github.com/anixwindy/web_htht ...
git push
if errorlevel 1 (
  echo.
  echo [ERROR] push failed. Nothing is live yet.
  echo         Commit is saved locally - fix the error, then run this again.
  pause
  exit /b 1
)

echo.
echo ==========================================================
echo   DONE.  Cloudflare is building now.
echo   Wait ~30s, then open:   https://segv0x41.com
echo   ^(hard refresh with Ctrl+F5^)
echo ==========================================================
echo.
pause
