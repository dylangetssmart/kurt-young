# External
import os
import argparse
import re
from dotenv import load_dotenv

# Lib
from lib.backup_db import backup_db
from lib.exec_conv import exec_conv
from lib.restore_db import restore_db
from lib.sql_runner import sql_runner
from lib.mapping import generate_mapping
from lib.initialize import initialize
# from lib.create_db import create_database

# Load environment variables
load_dotenv()
SERVER = os.getenv('SERVER')
NEEDLES_DB = os.getenv('SOURCE_DATABASE')
SA_DB = os.getenv('TARGET_DB')

# Constants
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def map(args):
    options = {
        'server': args.srv or SERVER,
        'database': args.db or SA_DB
    }

    generate_mapping(options)

def bu(args):
    options = {
        'server': args.srv or SERVER,
        'database': args.db or SA_DB,
        'directory': args.dir or os.path.join(os.getcwd(),'backups'),
        'sequence': args.seq
    }
    
    backup_db(options)

def exec(args):
    options = {
        'server': args.srv or SERVER,
        'database': args.db or SA_DB,
        'sequence': args.seq,
        'backup': args.bu
    }

    exec_conv(options)

def restore(args):
    options = {
        'server': args.srv or SERVER,
        'database': args.db or SA_DB,
        'virgin': args.v
    }

    restore_db(options)

def init(args):
    # options = {
    #     'server': args.srv or SERVER,
    #     'database': args.db or SA_DB,
    #     'system': args.system
    # }

    # initialize(options)
    server = args.srv or SERVER
    database = args.db or NEEDLES_DB
    init_dir = os.path.join(BASE_DIR, 'sql-scripts', 'initialize-needles')
    sql_pattern = re.compile(r'^.*\.sql$', re.I)

    print(f'Initializing Needles database {server}.{database}...')
    try:
        # List all files in the initialization directory
        all_files = os.listdir(init_dir)
        # Filter files that match the SQL pattern
        files = [file for file in all_files if sql_pattern.match(file)]

        if not files:
            print(f'No scripts found in {init_dir}.')
        else:
            for file in files:
                sql_file_path = os.path.join(init_dir, file)
                # print(f'Executing script: {sql_file_path}')
                sql_runner(sql_file_path, server, database)
    except Exception as e:
        print(f'Error reading directory {init_dir}\n{str(e)}')

def create_db(args):
    options = {
        'server': args.srv or SERVER,
        'database_name': args.name
    }

    # create_database(options)

def main():
    # Main entry point for the CLI.
    parser = argparse.ArgumentParser(description='Needles Conversion CLI.')
    subparsers = parser.add_subparsers(
        title="conversion operations",
        # help='sub-command help'
    )

    # Backup DB
    backup_parser = subparsers.add_parser('bu', help='Create database backups.')
    backup_parser.add_argument('seq', help='Sequence to stamp on .bak file.')
    backup_parser.add_argument('-dir', help='Backup directory.', metavar='')
    backup_parser.add_argument('-srv', help='Server name.', metavar='')
    backup_parser.add_argument('-db', help='Database to backup.', metavar='')
    backup_parser.set_defaults(func=bu)

    # Execute conversion
    exec_parser = subparsers.add_parser('exec', help='Run SQL scripts.')
    exec_parser.add_argument('seq', help='Script sequence to execute.', choices=[0,1,2,3,4,5], type=int)
    # exec_parser.add_argument('seq', help='Script sequence to execute.', choices=['0','1','2','3','4','5','a','p','q'])
    exec_parser.add_argument('-bu', action='store_true', help='Backup SA database after script execution.')
    exec_parser.add_argument('-srv', help='Server name.', metavar='')
    exec_parser.add_argument('-db', help='Database to execute against.', metavar='')
    exec_parser.set_defaults(func=exec)

    # Restore DB
    restore_db_parser = subparsers.add_parser('restore', help='Restore a database from a backup file.')
    restore_db_parser.add_argument('-srv', help='Server name.', metavar='')
    restore_db_parser.add_argument('-db', help='Database to restore. Defaults to SA_DB', metavar='')
    restore_db_parser.add_argument('-v', '--virgin', action='store_true', help='Restore to virgin state.', metavar='')
    restore_db_parser.set_defaults(func=restore)

    # Initiliaze Needles DB
    initialize_needles_parser = subparsers.add_parser('init', help='Initialize Needles database with functions and indexes.')
    initialize_needles_parser.add_argument('-srv', help='Server name.', metavar='')
    initialize_needles_parser.add_argument('-db', help='Needles database to initialize.', metavar='')
    initialize_needles_parser.set_defaults(func=init)

    # Generate Mapping Template
    mapping_parser = subparsers.add_parser('map', help='Generate Excel mapping template.')
    mapping_parser.set_defaults(func=map)

    # Create DB
    # create_db_parser = subparsers.add_parser('create-db', help='Create a SQL Server database.')
    # create_db_parser.add_argument('-srv', help='Server name.', metavar='')
    # create_db_parser.add_argument('name', help='Database name.', metavar='name')
    # create_db_parser.set_defaults(func=create_db)

    args = parser.parse_args()

    if 'func' not in args:
        parser.print_help()
    else:
        args.func(args)

if __name__ == "__main__":
    main()
