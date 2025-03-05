@echo off
setlocal

:: Set the SQL Server name
set SERVER_NAME=DYLANS

:: Prompt for the database name
set /p DATABASE_NAME="Enter the Needles database name: "

:: Get the directory of the batch script
set SCRIPT_DIR=%~dp0

:: Generate a timestamp for the log file
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set DATE=%%a-%%b-%%c
for /f "tokens=1-2 delims=:" %%a in ('time /t') do set TIME=%%a-%%b
set TIMESTAMP=%DATE%_%TIME%

:: Set the log file name
set LOG_FILE=%SCRIPT_DIR%log_%TIMESTAMP%.txt

:: Log the start of the process
echo Script execution started at %TIMESTAMP% > "%LOG_FILE%"
echo Server: %SERVER_NAME% >> "%LOG_FILE%"
echo Database: %DATABASE_NAME% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

:: Loop through all .sql files in the script directory
for %%f in (%SCRIPT_DIR%*.sql) do (
    echo Running script: %%f
    sqlcmd -S %SERVER_NAME% -d %DATABASE_NAME% -E -i "%%f" >> "%LOG_FILE%" 2>&1
    if %ERRORLEVEL% neq 0 (
        echo Error running script %%f >> "%LOG_FILE%"
    ) else (
        echo Successfully ran script %%f >> "%LOG_FILE%"
    )
    echo. >> "%LOG_FILE%"
)

echo All scripts executed successfully. >> "%LOG_FILE%"
echo Script execution completed at %date% %time% >> "%LOG_FILE%"

endlocal
start "" "%LOG_FILE%"
pause