# External
import os
import argparse
import re
from dotenv import load_dotenv

# Lib
from lib.backup_db import backup_db
from lib.exec_conv import exec_conv
from lib.revert_db import revert_db
from lib.sql_runner import sql_runner
from lib.mapping import generate_mapping

# Load environment variables
load_dotenv()
SERVER = os.getenv('SERVER')
NEEDLES_DB = os.getenv('SOURCE_DATABASE')
SA_DB = os.getenv('SA_DB')

# Constants
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def map(args):
    # Run queries against the Needles_DB
    server = args.srv or SERVER
    database = args.db or NEEDLES_DB
    options = {
        'server': server,
        'database': database
    }

    generate_mapping(options)

def bu(args):
    server = args.srv or SERVER
    database = args.db or SA_DB
    directory = args.directory or os.path.join(os.getcwd(),'backups')
    options = {
        'directory': directory,
        'step': args.step,
        'database': database,
        'server': server
    }
    
    backup_db(options)

def exec(args):
    server = args.srv or SERVER
    database = args.db or SA_DB
    options = {
        'server': server,
        'database': database,
        'sequence': args.sequence,
        'backup': args.backup
    }

    exec_conv(options)

def revert(args):
    server = args.srv or SERVER
    database = args.db or SA_DB
    options = {
        'server': server,
        'database': database
    }

    revert_db(options)

def init(args):
    print(f'Initializing Needles database...')
    server = args.srv or SERVER
    database = args.db or SA_DB
    init_dir = os.path.join(BASE_DIR, 'sql-scripts', 'initialize-needles')
    sql_pattern = re.compile(r'^.*\.sql$', re.I)
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

def main():
    # Main entry point for the CLI.
    parser = argparse.ArgumentParser(description='Needles Conversion CLI.')
    subparsers = parser.add_subparsers(
        title="conversion operations",
        # help='sub-command help'
    )

    # Backup DB
    backup_parser = subparsers.add_parser('bu', help='Create database backups.')
    backup_parser.add_argument(
        '-dir',
        help='Backup directory.',
        metavar=''
    )
    backup_parser.add_argument(
        '-srv',
        help='Server name.',
        metavar=''
    )
    backup_parser.add_argument(
        '-db',
        help='Database to backup.',
        metavar=''
    )
    backup_parser.add_argument(
        '-seq',
        required=True,
        help='Backup sequence description.',
        metavar=''
    )
    backup_parser.set_defaults(func=bu)

    # Execute conversion
    exec_parser = subparsers.add_parser('exec', help='Run SQL scripts.')
    exec_parser.add_argument(
        '-seq',
        help='Script sequence to execute.',
        choices=['0','1','2','3','4','5','a','p','q'],
        metavar=''
    )
    exec_parser.add_argument(
        '-bu',
        action='store_true',
        help='Backup SA database after script execution.'
    )
    exec_parser.add_argument(
        '-srv',
        help='Server name.',
        metavar=''
    )
    exec_parser.add_argument(
        '-db',
        help='Database to backup.',
        metavar=''
    )
    exec_parser.set_defaults(func=exec)


    # Revert DB
    revert_db_parser = subparsers.add_parser('revert', help='Revert a database from a backup file.')
    revert_db_parser.add_argument(
        '-srv',
        help='Server name.',
        metavar=''
    )
    revert_db_parser.add_argument(
        '-db',
        help='Database to backup.',
        metavar=''
    )
    revert_db_parser.set_defaults(func=revert)

    # hello_parser = subparsers.add_parser('hello', help='test')
    # hello_parser.add_argument('name', type=str, help="enter name")

    # Initiliaze Needles DB
    initialize_needles_parser = subparsers.add_parser('init', help='Initialize Needles database with functions and indexes.')
    initialize_needles_parser.add_argument(
        '-srv',
        help='Server name.',
        metavar=''
    )
    initialize_needles_parser.set_defaults(func=init)

    # Generate Mapping Template
    mapping_parser = subparsers.add_parser(
        'map',
        help='Generate Excel mapping template.'
    )
    mapping_parser.add_argument(
        '-srv',
        help='Server name.',
        metavar=''
    )
    mapping_parser.add_argument(
        '-db',
        help='Database to backup.',
        metavar=''
    )
    mapping_parser.set_defaults(func=map)


    args = parser.parse_args()

    if 'func' not in args:
        parser.print_help()
    else:
        args.func(args)

    # if args.command == 'bu':
    #     bu(args)
    # elif args.command == 'exec':
    #     exec(args)
    # elif args.command == 'revert':
    #     revert(args)
    # elif args.command == 'init':
    #     revert(args)
    # else:
    #     parser.print_help()

if __name__ == "__main__":
    main()
