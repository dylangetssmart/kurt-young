@echo off
setlocal enabledelayedexpansion

REM Set database connection variables
set SERVER=DYLANS

REM Directory containing your SQL scripts
set SCRIPTS_DIR=C:\LocalConv\NeedlesKMY\scripts\conv

REM Get current date and time in a format suitable for filenames (YYYY-MM-DD_HH-MM)
for /f "tokens=2 delims==." %%a in ('wmic os get localdatetime /value') do set "dt=%%a"
set "datetime=!dt:~0,4!-!dt:~4,2!-!dt:~6,2!_!dt:~8,2!-!dt:~10,2!"

REM Log file for error messages
set LOG_FILE=error_log_!datetime!.txt

REM Initialize log file
echo Error Log for SQL Script Execution > "!LOG_FILE!"
echo. >> "!LOG_FILE!"

REM Create ErrorLog table if not exists
sqlcmd -S !SERVER! -E -d SANeedlesKMY -Q "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ErrorLog') CREATE TABLE ErrorLog (ErrorID INT PRIMARY KEY IDENTITY, ScriptName NVARCHAR(255), Status NVARCHAR(50) DEFAULT 'Success', ExecutionTime DATETIME DEFAULT GETDATE(), OutputFilePath NVARCHAR(255));"

REM Menu for script execution options
:MENU
echo Please select an option:
echo A. Run all SQL scripts
echo 0. Run initialize scripts (filenames starting with 0*_*)
echo 1. Run contact scripts (filenames starting with 1*_*)
echo 2. Run case scripts (filenames starting with 2*_*)
echo 3. Run UDF scripts (filenames starting with 3*_*)
echo 4. Run Intake scripts (filenames starting with 4*_*)
echo Q. Quit

REM Prompt user for choice
set /p CHOICE=Enter your choice: 

REM Execute based on user choice
if /i "%CHOICE%"=="A" (
    REM Execute all SQL scripts in the directory
    for %%f in ("%SCRIPTS_DIR%\*.sql") do (
        call :RunScript "%%f"
    )
) else if /i "%CHOICE%"=="0" (
    REM Execute initialize scripts (filenames starting with 0*_*)
    for %%f in ("%SCRIPTS_DIR%\0*.sql") do (
        call :RunScript "%%f"
    )
) else if /i "%CHOICE%"=="1" (
    REM Execute contact scripts (filenames starting with 1*_*)
    for %%f in ("%SCRIPTS_DIR%\1*.sql") do (
        call :RunScript "%%f"
    )
) else if /i "%CHOICE%"=="2" (
    REM Execute case scripts (filenames starting with 2*_*)
    for %%f in ("%SCRIPTS_DIR%\2*.sql") do (
        call :RunScript "%%f"
    )
) else if /i "%CHOICE%"=="3" (
    REM Execute case scripts (filenames starting with 2*_*)
    for %%f in ("%SCRIPTS_DIR%\3*.sql") do (
        call :RunScript "%%f"
    )
) else if /i "%CHOICE%"=="4" (
    REM Execute case scripts (filenames starting with 2*_*)
    for %%f in ("%SCRIPTS_DIR%\4*.sql") do (
        call :RunScript "%%f"
    )
) else if /i "%CHOICE%"=="Q" (
    echo Exiting script.
    goto :EOF
) else (
    echo Invalid choice. Please try again.
    goto MENU
)

goto :EOF

REM Function to run a SQL script
:RunScript
set SCRIPT=%~1
echo Running script: %SCRIPT% >> "!LOG_FILE!"

REM Execute SQL script and capture output
sqlcmd -S !SERVER! -E -d SANeedlesKMY -i "%SCRIPT%" -b -h -1 > NUL 2>&1

if ERRORLEVEL 1 (
    REM Create output file named after script
    set "OUTPUT_FILE=%SCRIPT%_!datetime!.out"
    sqlcmd -S !SERVER! -E -d SANeedlesKMY -i "%SCRIPT%" -o "!OUTPUT_FILE!" -b -r 1 > NUL 2>&1

    REM Log error into ErrorLog table with output file path
    sqlcmd -S !SERVER! -E -d SANeedlesKMY -Q "INSERT INTO ErrorLog (ScriptName, Status, ExecutionTime, OutputFilePath) VALUES ('%SCRIPT%', 'Error', GETDATE(), '!OUTPUT_FILE!');" -b > NUL 2>&1
    
    REM Write failure message to log
    echo FAIL - %SCRIPT% >> "!LOG_FILE!"
    echo     Timestamp: !datetime! >> "!LOG_FILE!"
    echo     Output File: !OUTPUT_FILE! >> "!LOG_FILE!"
    echo. >> "!LOG_FILE!"
    echo FAIL - %SCRIPT%
    
    REM Open the output file in default text editor (assuming .out files are associated with a text editor)
    REM start "" "!OUTPUT_FILE!"
) else (
    REM Log successful execution into ErrorLog table
    sqlcmd -S !SERVER! -E -d SANeedlesKMY -Q "INSERT INTO ErrorLog (ScriptName, Status, ExecutionTime) VALUES ('%SCRIPT%', 'Success', GETDATE());" -b > NUL 2>&1
    
    REM Write success message to log
    echo SUCCESS - %SCRIPT% >> "!LOG_FILE!"
    echo     Timestamp: !datetime! >> "!LOG_FILE!"
    echo. >> "!LOG_FILE!"
    echo SUCCESS - %SCRIPT%
)

goto :EOF
