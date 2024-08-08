import os
import pandas as pd
import time
from sqlalchemy import create_engine
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
SERVER = os.getenv('SERVER')
SA_DB = os.getenv('SA_DB')

# Set up the database connection using SQLAlchemy
connection_string = f'mssql+pyodbc://{SERVER}/{SA_DB}?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes'
engine = create_engine(connection_string)

# Path to the directory containing the CSV files
base_dir = os.path.dirname(os.path.abspath(__file__))
csv_directory = os.path.join(base_dir, 'data')

# Path to the .txt file containing CSV file information
info_file_path = os.path.join(csv_directory, 'AllCSV_NumLines.txt')

# Path to save the progress Excel file
progress_file_path = os.path.join(base_dir, 'import_progress.xlsx')

# Parse the .txt file to get the list of files with data status
files_with_data = {}
with open(info_file_path, 'r', encoding='utf-16') as file:
    for line in file:
        parts = line.split()
        # From ../data/AllCSV_NumLines.ps1:
        # parts[0] = $Dir
        # parts[1] = $Name
        # parts[2] = $Size
        # parts[3] = $hasData
        # parts[4] = $linecount
        if len(parts) >= 4:
            # Normalize the file path
            file_path = os.path.join(parts[0], parts[1])
            has_data = parts[3] == '1'
            file_name = os.path.basename(file_path)
            files_with_data[file_name] = {
                'has_data': has_data,
                'line_count': int(parts[4])  # Number of lines from source file
            }

# DataFrame to record progress
progress_df = pd.DataFrame(columns=['File Name', 'Lines in Source', 'Records Imported', 'Time to Import (s)', 'Status'])

# Function to import data from CSV to SQL Server
def import_csv_to_sql(file_path, table_name):
    start_time = time.time()  # Start timing
    file_name = os.path.basename(file_path)
    line_count = files_with_data[os.path.basename(file_path)]['line_count']

    print(f'Importing {file_name}: {line_count} lines')
    # Read CSV file into DataFrame
    try:
        try:
            df = pd.read_csv(file_path, encoding='utf-8', low_memory=False)
        except UnicodeDecodeError:
            df = pd.read_csv(file_path, encoding='ISO-8859-1', low_memory=False)

        # Check if DataFrame has data (i.e., more than just the column headers)
        if not df.empty:
            # Write the DataFrame to the SQL table
            df.to_sql(table_name, engine, if_exists='replace', index=False)
            records_imported = len(df)
            status = 'Success'
            print(f"Success: Imported {file_name} into table {table_name}.")
        else:
            records_imported = 0
            status = 'Skipped: Empty'
            print(f"Skipped: {file_name} is empty.")

    except Exception as e:
        records_imported = 0
        status = f'Failure: {e}'
        print(f"Failure: Could not import {file_name}. Error: {e}")

    end_time = time.time()  # End timing
    time_to_import = end_time - start_time

    # Record progress
    progress_df.loc[len(progress_df)] = [
        os.path.basename(file_path),
        files_with_data[os.path.basename(file_path)]['line_count'],
        records_imported,
        time_to_import,
        status
    ]

# Record start time
start_time = time.time()

for file_name, data in files_with_data.items():
    if data['has_data']:
        file_path = os.path.join(csv_directory, file_name)
        table_name = os.path.splitext(file_name)[0]  # Use file name (without extension) as table name
        import_csv_to_sql(file_path, table_name)

# Save progress to Excel
progress_df.to_excel(progress_file_path, index=False)

# Record the end time and calculate execution time
end_time = time.time()
execution_time_seconds = end_time - start_time

# Convert execution time to hours, minutes, and seconds
hours = int(execution_time_seconds // 3600)
minutes = int((execution_time_seconds % 3600) // 60)
seconds = int(execution_time_seconds % 60)

print(f"Execution time: {hours} hours, {minutes} minutes, {seconds} seconds")
