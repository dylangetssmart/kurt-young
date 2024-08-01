import os
import subprocess
import tkinter as tk
from tkinter import filedialog
from dotenv import load_dotenv

load_dotenv()

def select_bak_file():
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename(
        title="Select the .bak file to restore",
        filetypes=[("SQL Backup Files", "*.bak")]
    )
    return file_path

def main():
    # SERVER = 'DylanS\\MSSQLSERVER2022'
    SERVER = os.getenv('SERVER')  # Retrieve server from environment variables
    DATABASE = os.getenv('SA_DB')  # Retrieve database from environment variables

    if not SERVER:
        print("Server environment variable is not set.")
        return

    if not DATABASE:
        print("Database environment variable is not set.")
        return

    # Prompt for database name
    # DATABASE = input("Enter the name of the database to restore: ")

    # if not DATABASE:
    #     print("Database name cannot be empty. Exiting script.")
    #     return

    # Prompt user to select .bak file using file dialog
    print("Select the .bak file to restore:")
    FILE = select_bak_file()

    if not FILE:
        print("No file selected. Exiting script.")
        return

    # Put the database in single user mode
    print(f"\nPutting database {DATABASE} in single user mode ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', SERVER, '-Q', f"ALTER DATABASE [{DATABASE}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;", '-b', '-d', 'master'],
            check=True
        )
    except subprocess.CalledProcessError:
        print(f"Failed to set database {DATABASE} to single user mode. Exiting script.")
        return

    # Restore the database
    print(f"\nRestoring database {DATABASE} from {FILE} ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', SERVER, '-Q', f"RESTORE DATABASE [{DATABASE}] FROM DISK='{FILE}' WITH REPLACE, RECOVERY;", '-b', '-d', 'master'],
            check=True
        )
        print(f"Database {DATABASE} restored successfully from {FILE}.")
    except subprocess.CalledProcessError:
        print("Database restore failed. Check the SQL Server error log for details.")
        return

    # Set the database back to multi-user mode
    print(f"\nPutting database {DATABASE} back in multi-user mode ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', SERVER, '-Q', f"ALTER DATABASE [{DATABASE}] SET MULTI_USER;", '-b', '-d', 'master'],
            check=True
        )
    except subprocess.CalledProcessError:
        print(f"Failed to set database {DATABASE} back to multi-user mode. Manual intervention may be required.")

if __name__ == "__main__":
    main()
