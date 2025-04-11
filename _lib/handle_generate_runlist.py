import os
from generate_runlist import generate_runlist

def handle_generate_runlist(sql_dir):
    """
    Generate a _runlist.txt file in every directory that contains .sql files.

    Args:
        sql_dir (str): Path to the 'sql' directory.
    """
    for dirpath, _, filenames in os.walk(sql_dir):
        # Skip directories that start with an underscore
        if any(part.startswith("_") for part in dirpath.split(os.sep)):
            continue

        # Filter out .sql files
        sql_files = [f for f in filenames if f.lower().endswith(".sql")]

        if sql_files:
            try:
                generate_runlist(dirpath)  # writes _runlist.txt in the same directory
                print(f"Generated _runlist.txt in {dirpath}")
            except Exception as e:
                print(f"Error generating runlist in {dirpath}: {e}")

if __name__ == "__main__":
    sql_dir = "sql"  # Adjust this path if necessary
    handle_generate_runlist(sql_dir)
