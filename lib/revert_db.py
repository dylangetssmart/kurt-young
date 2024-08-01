import os
import subprocess
import tkinter as tk
from tkinter import filedialog
from dotenv import load_dotenv

load_dotenv()

def select_bak_backup_file():
    root = tk.Tk()
    root.withdraw()
    backup_file_path = filedialog.askopenfile(
        title="Select the .bak backup_file to restore",
        filetypes=[("SQL Backup backup_files", "*.bak")],
        initialdir='C:\LocalConv'
    )
    return backup_file_path

def revert_db():
    # server = 'DylanS\\MSSQLserver2022'
    server = os.getenv('server')  # Retrieve server from environment variables
    database = os.getenv('SA_DB')  # Retrieve database from environment variables

    print(server)
    print(database)
    # print(backup_file)

    if not server:
        print("Missing server parameter.")
        return

    if not database:
        print("Missing database parameter.")
        return
    
    # if not backup_file:
    #     print("Missing backup backup_file parameter.")
    #     return

    # Prompt for database name
    # database = input("Enter the name of the database to restore: ")

    # if not database:
    #     print("database name cannot be empty. Exiting script.")
    #     return

    # Prompt user to select .bak backup_file using backup_file dialog
    print("Select the .bak backup_file to restore:")
    backup_file = select_bak_backup_file()

    # if not backup_file:
    #     print("No backup_file selected. Exiting script.")
    #     return

    # Put the database in single user mode
    print(f"\nPutting database {database} in single user mode ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', server, '-Q', f"ALTER database [{database}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;", '-b', '-d', 'master'],
            check=True
        )
    except subprocess.CalledProcessError:
        print(f"Failed to set database {database} to single user mode. Exiting script.")
        return

    # Restore the database
    print(f"\nRestoring database {database} from {backup_file} ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', server, '-Q', f"RESTORE database [{database}] FROM DISK='{backup_file}' WITH REPLACE, RECOVERY;", '-b', '-d', 'master'],
            check=True
        )
        print(f"database {database} restored successfully from {backup_file}.")
    except subprocess.CalledProcessError:
        print("database restore failed. Check the SQL server error log for details.")
        return

    # Set the database back to multi-user mode
    print(f"\nPutting database {database} back in multi-user mode ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', server, '-Q', f"ALTER database [{database}] SET MULTI_USER;", '-b', '-d', 'master'],
            check=True
        )
    except subprocess.CalledProcessError:
        print(f"Failed to set database {database} back to multi-user mode. Manual intervention may be required.")

# if __name__ == "__main__":
#     main()
