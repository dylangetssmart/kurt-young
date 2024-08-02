# External
import os
import argparse
# from datetime import datetime
from dotenv import load_dotenv

# Lib
from lib.backup_db import backup_db
from lib.exec_conv import exec_conv
from lib.revert_db import revert_db
from lib.hello import hello

# Load environment variables
load_dotenv()
SERVER = os.getenv('SERVER')
NEEDLES_DB = os.getenv('SOURCE_DATABASE')
SA_DB = os.getenv('SA_DB')

# Constants
# datetime_str = datetime.now().strftime('%Y-%m-%d_%H-%M')
# BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# SQL_SCRIPTS_DIR = os.path.join(BASE_DIR, '../sql-scripts/conv/')
# LOGS_DIR = os.path.join(BASE_DIR, '../logs')
# LOG_FILE = os.path.join(LOGS_DIR, f'error_log_{datetime_str}.txt')

def bu(args):
    server = args.server or SERVER
    database = args.database or SA_DB
    directory = args.directory or os.path.join(os.getcwd(),'backups')
    options = {
        'directory': directory,
        'step': args.step,
        'database': database,
        'server': server
    }
    backup_db(options)

def exec(args):
    server = args.server or SERVER
    database = args.database or SA_DB
    options = {
        'server': server,
        'database': database,
        'sequence': args.sequence,
        'backup': args.backup
    }
    exec_conv(options)

def revert(args):
    server = args.server or SERVER
    database = args.database or SA_DB

    options = {
        'server': server,
        'database': database
    }
    revert_db(options)

# def hello_cmd(args):
    # hello(args.name)

def main():
    # Main entry point for the CLI.
    parser = argparse.ArgumentParser(description='Database management CLI.')
    subparsers = parser.add_subparsers(
        title="subcommands",
        description="conversion operations",
        dest='command'
    )

    # Backup DB
    backup_parser = subparsers.add_parser('bu', help='Create database backups.')
    backup_parser.add_argument('--directory',  help='Backup directory.')
    backup_parser.add_argument('--database', help='Database to backup.')
    backup_parser.add_argument('-s','--sequence',required=True, help='Backup sequence description.')
    backup_parser.add_argument('--server', help='Server name.')

    # Execute conversion
    exec_parser = subparsers.add_parser('exec', help='Run SQL scripts.')
    exec_parser.add_argument('-s', '--sequence',
                                    help='Enter the sequence of scripts to execute.',
                                    choices=['0','1','2','3','4','5','a','p','q']
                                    )
    exec_parser.add_argument('-bu', '--backup', action='store_true', help='Create database backups before running scripts.')
    exec_parser.add_argument('--server', help='Server name.')
    exec_parser.add_argument('--database', help='Database to backup.')

    # Revert DB
    revert_db_parser = subparsers.add_parser('rev', help='Revert a database from a backup file.')
    revert_db_parser.add_argument('--server', help='Server name.')
    revert_db_parser.add_argument('--database', help='Database to backup.')
    # hello_parser = subparsers.add_parser('hello', help='test')
    # hello_parser.add_argument('name', type=str, help="enter name")

    args = parser.parse_args()

    if args.command == 'bu':
        bu(args)
    elif args.command == 'exec':
        exec(args)
    elif args.command == 'rev':
        revert(args)
    # elif args.command == 'hello':
    #     hello(args.name)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
