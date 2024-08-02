import os
import subprocess
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

def backup_db(options):
    # directory = options['directory']
    # step = options['step']
    # database = options['databaseName1']
    # # server = options['server']
    # server = os.getenv('SERVER')
    directory = options.get('directory')
    step = options.get('step')
    database = options.get('database')
    # server = options['server']
    server = os.getenv('SERVER')
    # database_name2 = options['databaseName2']

    print(directory, step, database, server)

    if not server:
        raise ValueError("Server environment variable is not set.")

    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M')
    backup_path1 = os.path.join(directory, f'{database}-afterStep-{step}_{timestamp}.bak')
    # backup_path2 = os.path.join(directory, f'{database_name2}-after-{step}_{timestamp}.bak')

    # Ensure the backup directory exists
    if not os.path.exists(directory):
        os.makedirs(directory)

    backup_command1 = f"sqlcmd -S {server} -Q \"BACKUP DATABASE [{database}] TO DISK = '{backup_path1}' WITH FORMAT, INIT, NAME = '{database} Full Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10\""
    # backup_command2 = f"sqlcmd -S {server} -Q \"BACKUP DATABASE [{database_name2}] TO DISK = '{backup_path2}' WITH FORMAT, INIT, NAME = '{database_name2} Full Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10\""

    try:
        subprocess.run(backup_command1, check=True, shell=True)
        print(f"Backup for {database} completed successfully at {directory}.")
    except subprocess.CalledProcessError as error:
        print(f"Error backing up database {database}:", error)

    # try:
    #     subprocess.run(backup_command2, check=True, shell=True)
    #     print(f"Backup for {database_name2} completed successfully at {directory}.")
    # except subprocess.CalledProcessError as error:
    #     print(f"Error backing up database {database_name2}:", error)
