import os
from datetime import datetime
import re
from dotenv import load_dotenv
from lib.backup_db import create_database_backups
from lib.sql_runner import run_sql_script
# from lib.logger import log_message

load_dotenv()

# Variables & Constants
# SERVER = 'DYLANS\\MSSQLSERVER2022'
# NEEDLES_DB = 'NeedlesSLF'
# SA_DB = 'SANeedlesSLF'
datetime_str = datetime.now().strftime('%Y-%m-%d_%H-%M')
SERVER = os.getenv('SERVER')
NEEDLES_DB = os.getenv('SOURCE_DATABASE')
SA_DB = os.getenv('SA_DB')
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SQL_SCRIPTS_DIR = os.path.join(BASE_DIR, '../sql-scripts/conv/')
LOGS_DIR = os.path.join(BASE_DIR, '../logs')
LOG_FILE = os.path.join(LOGS_DIR, f'error_log_{datetime_str}.txt')

# Menu for script execution options
menu_options = {
    'A': {'description': 'All', 'pattern': re.compile(r'^.*\.sql$', re.I)},
    '0': {'description': 'Initialize', 'pattern': re.compile(r'^0.*\.sql$', re.I)},
    '1': {'description': 'Contact', 'pattern': re.compile(r'^1.*\.sql$', re.I)},
    '2': {'description': 'Case', 'pattern': re.compile(r'^2.*\.sql$', re.I)},
    '3': {'description': 'UDF', 'pattern': re.compile(r'^3.*\.sql$', re.I)},
    '4': {'description': 'Misc', 'pattern': re.compile(r'^4.*\.sql$', re.I)},
    '5': {'description': 'Intake', 'pattern': re.compile(r'^5.*\.sql$', re.I)},
    'P': {'description': 'Post', 'pattern': re.compile(r'^post.*\.sql$', re.I)},
    'Q': {'description': 'Quit', 'pattern': None}
}

# Display menu and prompt user for choice
print('Select scripts to run:')
for key, option in menu_options.items():
    print(f'{key}. {option["description"]}')

choice = input('Enter your choice: ').upper()
selected_option = menu_options.get(choice)

if selected_option and selected_option['pattern']:
    try:
        all_files = os.listdir(SQL_SCRIPTS_DIR)
        files = [file for file in all_files if selected_option['pattern'].match(file)]

        if not files:
            print(f'No scripts found for pattern: {selected_option["pattern"]}')
        else:
            for file in files:
                run_sql_script(os.path.join(SQL_SCRIPTS_DIR, file), SERVER, SA_DB, LOGS_DIR, datetime_str)
    except Exception as e:
        print(f'Error reading directory {SQL_SCRIPTS_DIR}\n', str(e))
elif choice == 'Q':
    print('Exiting script.')
else:
    print('Invalid choice. Please try again.')

# Create db backups
if choice != 'Q':
    create_database_backups({
        'databaseName1': SA_DB,
        # 'databaseName2': NEEDLES_DB,
        'directory': os.path.join(BASE_DIR, '../backups'),
        'step': selected_option['description'],
        'server': SERVER
    })
