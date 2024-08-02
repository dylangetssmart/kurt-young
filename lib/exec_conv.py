import os
from datetime import datetime
import re
# from dotenv import load_dotenv
from lib.backup_db import backup_db
from lib.sql_runner import sql_runner
# from lib.logger import log_message

# load_dotenv()

# Variables & Constants
# SERVER = 'DYLANS\\MSSQLSERVER2022'
# NEEDLES_DB = 'NeedlesSLF'
# SA_DB = 'SANeedlesSLF'
datetime_str = datetime.now().strftime('%Y-%m-%d_%H-%M')
# SERVER = os.getenv('SERVER')
# NEEDLES_DB = os.getenv('SOURCE_DATABASE')
# SA_DB = os.getenv('SA_DB')
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SQL_SCRIPTS_DIR = os.path.join(BASE_DIR, '../sql-scripts/conv/')
# LOGS_DIR = os.path.join(BASE_DIR, '../logs')
# LOG_FILE = os.path.join(LOGS_DIR, f'error_log_{datetime_str}.txt')

# menu_options = {
#     'A': {'description': 'All', 'pattern': re.compile(r'^.*\.sql$', re.I)},
#     '0': {'description': 'Initialize', 'pattern': re.compile(r'^0.*\.sql$', re.I)},
#     '1': {'description': 'Contact', 'pattern': re.compile(r'^1.*\.sql$', re.I)},
#     '2': {'description': 'Case', 'pattern': re.compile(r'^2.*\.sql$', re.I)},
#     '3': {'description': 'UDF', 'pattern': re.compile(r'^3.*\.sql$', re.I)},
#     '4': {'description': 'Misc', 'pattern': re.compile(r'^4.*\.sql$', re.I)},
#     '5': {'description': 'Intake', 'pattern': re.compile(r'^5.*\.sql$', re.I)},
#     'P': {'description': 'Post', 'pattern': re.compile(r'^post.*\.sql$', re.I)},
#     'Q': {'description': 'Quit', 'pattern': None}
# }

sequence_patterns = {
    'A': re.compile(r'^.*\.sql$', re.I),
    '0': re.compile(r'^0.*\.sql$', re.I),
    '1': re.compile(r'^1.*\.sql$', re.I),
    '2': re.compile(r'^2.*\.sql$', re.I),
    '3': re.compile(r'^3.*\.sql$', re.I),
    '4': re.compile(r'^4.*\.sql$', re.I),
    '5': re.compile(r'^5.*\.sql$', re.I),
    'P': re.compile(r'^post.*\.sql$', re.I)
}

# def prompt_for_backup():
#     backup_choice = input('Do you want to create database backups before running scripts? (Y/N): ').upper()
#     return backup_choice == 'Y'

def exec_conv(options):
    server = options.get('server')
    database = options.get('database')
    sequence = options.get('sequence')
    backup = options.get('backup', False)

    if not sequence or sequence not in sequence_patterns:
        print('Invalid sequence option.')
        return
    
    selected_pattern = sequence_patterns[sequence]

    print(f'Executing scripts against {server}.{database}')


    try:
        all_files = os.listdir(SQL_SCRIPTS_DIR)
        files = [file for file in all_files if selected_pattern.match(file)]

        if not files:
            print(f'No scripts found for pattern: {selected_pattern}')
        else:
            for file in files:
                sql_runner(
                    os.path.join(SQL_SCRIPTS_DIR, file),
                    server,
                    database,
                )
    except Exception as e:
        print(f'Error reading directory {SQL_SCRIPTS_DIR}\n', str(e))

    if backup:    
        backup_db({
            'database': database,
            'directory': os.path.join(BASE_DIR, '../backups'),
            'step': sequence,
            'server': server
        })