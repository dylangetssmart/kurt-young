# External
import argparse
import os
import re
from datetime import datetime
from dotenv import load_dotenv
from tkinter import Tk
from tkinter.filedialog import askopenfilename

# Lib
from lib.backup_db import backup_db
from lib.sql_runner import run_sql_script
from lib.revert_db import revert_db
from lib.hello import hello

# Load environment variables
load_dotenv()

# Constants
datetime_str = datetime.now().strftime('%Y-%m-%d_%H-%M')
SERVER = os.getenv('SERVER')
NEEDLES_DB = os.getenv('SOURCE_DATABASE')
SA_DB = os.getenv('SA_DB')
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SQL_SCRIPTS_DIR = os.path.join(BASE_DIR, '../sql-scripts/conv/')
LOGS_DIR = os.path.join(BASE_DIR, '../logs')
LOG_FILE = os.path.join(LOGS_DIR, f'error_log_{datetime_str}.txt')

def backup_db_cmd(args):
    server = args.server or SERVER
    database = args.database or os.getenv('SA_DB')
    directory = args.directory or os.path.join(os.getcwd(),'backups')
    # print(os.path.join(os.getcwd(),'backups'))
    options = {
        'directory': directory,
        'step': args.step,
        'database': database,
        'server': server
    }
    backup_db(options)

def run_scripts_cmd(args):
    if not os.path.isdir(args.script_directory):
        print(f"Directory {args.script_directory} does not exist.")
        return

    print(f"Running scripts from {args.script_directory} on server {args.server}...")

    try:
        all_files = os.listdir(args.script_directory)
        for file in all_files:
            if file.endswith('.sql'):
                run_sql_script(
                    os.path.join(args.script_directory, file),
                        args.server,
                        args.database,
                        args.logs_dir,
                        args.datetime_str
                    )
    except Exception as e:
        print(f'Error running scripts: {str(e)}')

def revert_db_cmd(args):
    # server = args.server or SERVER
    # database = args.database or os.getenv('SOURCE_DATABASE')

    # print(f'server')
    # if not server:
    #     print('Server is required.')
    #     return
    
    # if not database:
    #     print('Database is required.')
    #     return
    
    # # Use provided backup file path or open file dialog to select a .bak file
    # if args.backup_file:
    #     backup_file = args.backup_file
    # else:
    #     root = Tk()
    #     root.withdraw()  # Hide the root window
    #     backup_file = askopenfilename(
    #         filetypes=[("SQL Backup Files", "*.bak")],
    #         title="Select the .bak file to restore"
    #     )

    # if not backup_file:
    #     print('No backup file selected.')
    #     return

    # revert_db(
    #     server=server,
    #     database=database,
    #     backup_file=backup_file
    # )
    revert_db()

def hello_cmd(args):
    hello(args.name)

def main():
    # Main entry point for the CLI.
    parser = argparse.ArgumentParser(description='Database management CLI.')
    subparsers = parser.add_subparsers(
        title="subcommands",
        description="conversion operations",
        dest='command'
    )

    # Backup DB command
    backup_parser = subparsers.add_parser('bu', help='Create database backups.')
    backup_parser.add_argument('--directory',  help='Backup directory.')
    backup_parser.add_argument('--database', help='Database to backup.')
    backup_parser.add_argument('-s','--step',required=True, help='Backup step description.')
    backup_parser.add_argument('--server', help='Server name.')

    # Run Scripts command
    run_scripts_parser = subparsers.add_parser('exec', help='Run SQL scripts.')
    # run_scripts_parser.add_argument('script_directory', help='Directory containing SQL scripts.')
    # run_scripts_parser.add_argument('server', help='Server name.')
    # run_scripts_parser.add_argument('database', help='Database name.')
    # run_scripts_parser.add_argument('logs_dir', help='Directory to store logs.')
    # run_scripts_parser.add_argument('datetime_str', help='Timestamp string for logging.')

    # Revert DB command
    revert_db_parser = subparsers.add_parser('rev', help='Revert a database from a backup file.')
    # revert_db_parser.add_argument('-s', '--server', help='Server name (overrides .env value).')
    # revert_db_parser.add_argument('-d', '--database', help='Database name (overrides .env value).')
    # revert_db_parser.add_argument('-f', '--backup_file', help='Path to the .bak file.')

    hello_parser = subparsers.add_parser('hello', help='test')
    hello_parser.add_argument('name', type=str, help="enter name")

    args = parser.parse_args()

    if args.command == 'bu':
        backup_db_cmd(args)
    elif args.command == 'exec':
        run_scripts_cmd(args)
    elif args.command == 'rev':
        revert_db_cmd()
    elif args.command == 'hello':
        hello(args.name)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
