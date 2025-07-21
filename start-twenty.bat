@echo off
echo Starting Twenty CRM...
echo.

echo Checking prerequisites...
netstat -an | findstr ":5432" >nul
if errorlevel 1 (
    echo ERROR: PostgreSQL not running on port 5432
    pause
    exit /b 1
)

netstat -an | findstr ":6379" >nul
if errorlevel 1 (
    echo ERROR: Redis not running on port 6379
    pause
    exit /b 1
)

echo Prerequisites OK!
echo.

echo Starting Backend Server...
start "Twenty Backend" powershell -Command "cd D:\program\twenty\packages\twenty-server; $env:NODE_ENV='development'; npx nest start --watch"

echo Waiting 5 seconds for backend to initialize...
timeout /t 5 /nobreak >nul

echo Starting Frontend Server...
start "Twenty Frontend" powershell -Command "cd D:\program\twenty; npx nx start twenty-front"

echo.
echo Twenty CRM is starting up...
echo Backend: http://localhost:3000
echo Frontend: http://localhost:3001
echo.
echo Press any key to exit...
pause >nul
