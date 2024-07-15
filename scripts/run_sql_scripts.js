const { execSync } = require('child_process');
const { readdirSync, writeFileSync, appendFileSync } = require('fs');
const path = require('path');

const SERVER = 'DYLANS';
const DATABASE = 'SANeedlesSLF';
const BASE_DIR = __dirname;

let SQL_SCRIPTS_DIR = path.resolve(BASE_DIR, '../sql-scripts/conv');
const LOGS_DIR = path.join(BASE_DIR, '../logs');
const LOG_FILE = path.join(LOGS_DIR, `error_log_${datetime}.txt`);

// (YYYY-MM-DD_HH-MM)
const datetime = new Date().toISOString().replace(/T/, '_').replace(/:/g, '-').split('.')[0];

// Initialize log file and logs directory
// const initializeLogs = () => {
//     ensureLogsDirectory();
//     writeFileSync(LOG_FILE, 'Error Log for SQL Script Execution\n\n');
// };

// Function to execute a SQL command
// function runSqlCmd(command, database = DATABASE) {
//     try {
//         execSync(`sqlcmd -S ${SERVER} -E -d ${database} -Q "${command}"`);
//     } catch (error) {
//         console.error(`Error running SQL command: ${command}\n`, error.message);
//     }
// }

// Create ErrorLog table if not exists
// runSqlCmd(`IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ErrorLog') CREATE TABLE ErrorLog (ErrorID INT PRIMARY KEY IDENTITY, ScriptName NVARCHAR(255), Status NVARCHAR(50) DEFAULT 'Success', ExecutionTime DATETIME DEFAULT GETDATE(), OutputFilePath NVARCHAR(255));`);

// Function to log messages to the log file
function logMessage(message) {
    appendFileSync(LOG_FILE, message + '\n');
    console.log(message);
}

// Function to run a SQL script
function runScript(scriptPath, database = DATABASE) {
    const scriptName = path.basename(scriptPath);
    logMessage(`Running script: ${scriptName}`);

    try {
        execSync(`sqlcmd -S ${SERVER} -E -d ${database} -i "${scriptPath}" -b -h -1`, { stdio: 'ignore' });
        logMessage(`SUCCESS - ${scriptName}`);
        logMessage(`    Timestamp: ${datetime}\n`);
    } catch (error) {
        const outputFilePath = path.join(LOGS_DIR, `${scriptName}_${datetime}.out`);
        logMessage(`FAIL - ${scriptName}`);
        logMessage(`    Timestamp: ${datetime}`);
        logMessage(`    Output File: ${outputFilePath}\n`);

        // Write error output to a file
        writeFileSync(outputFilePath, error.message);
        console.error(`FAIL - ${scriptName}`);
    }
}

// Menu for script execution options
const menuOptions = {
    'A': { description: 'Run all SQL scripts', pattern: /^.*\.sql$/i },
    '0': { description: 'Run initialize scripts', pattern: /^0.*\.sql$/i },
    '1': { description: 'Run contact scripts', pattern: /^1.*\.sql$/i },
    '2': { description: 'Run case scripts', pattern: /^2.*\.sql$/i },
    '3': { description: 'Run UDF scripts', pattern: /^3.*\.sql$/i },
    '4': { description: 'Run Intake scripts', pattern: /^4.*\.sql$/i },
    'Q': { description: 'Quit', pattern: null }
};

// Display menu and prompt user for choice
const readlineSync = require('readline-sync');
console.log('Please select an option:');
Object.keys(menuOptions).forEach(key => {
    console.log(`${key}. ${menuOptions[key].description}`);
});

const choice = readlineSync.question('Enter your choice: ').toUpperCase();
const selectedOption = menuOptions[choice];

if (selectedOption && selectedOption.pattern) {
    try {
        console.log(`Checking for scripts in directory: ${SQL_SCRIPTS_DIR}`);
        const allFiles = readdirSync(SQL_SCRIPTS_DIR);
        console.log('Files in directory:', allFiles);

        const files = allFiles.filter(file => selectedOption.pattern.test(file));
        console.log(`Matching files for pattern ${selectedOption.pattern}:`, files);

        if (files.length === 0) {
            console.log(`No scripts found for pattern: ${selectedOption.pattern}`);
        } else {
            files.forEach(file => runScript(path.join(SQL_SCRIPTS_DIR, file), DATABASE));
        }
    } catch (error) {
        console.error(`Error reading directory ${SQL_SCRIPTS_DIR}\n`, error.message);
    }
} else if (choice === 'Q') {
    console.log('Exiting script.');
} else {
    console.log('Invalid choice. Please try again.');
}
