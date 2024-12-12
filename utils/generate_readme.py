import os

def generate_system_readmes(sql_dir):
    """
    Generate a README.md (or README2.md) file for each system directory,
    including nested subdirectories at any depth. Only generate tables for directories
    that contain .sql files.
    
    Args:
        sql_dir (str): Path to the 'sql' directory.
    """
    # Iterate over system directories in the SQL directory
    for system_dir in os.listdir(sql_dir):
        system_path = os.path.join(sql_dir, system_dir)

        # Skip non-directories and directories starting with an underscore
        if not os.path.isdir(system_path) or system_dir.startswith("_"):
            continue

        # Define the readme path for the system directory (e.g., sql\needles\README2.md)
        readme_path = os.path.join(system_path, "Readme.md")
        content = f"# {system_dir.capitalize()}\n\n"

        # Call the function to gather scripts from all subdirectories
        content += process_subdirectories(system_path)

        # Write the content to the README2.md file
        with open(readme_path, "w", encoding="utf-8") as readme_file:
            readme_file.write(content)
        print(f"Updated {readme_path}")

def process_subdirectories(current_dir):

    content = ""

    # os.walk generates a 3-tuple (dirpath, dirnames, filenames)
    for dirpath, dirnames, filenames in os.walk(current_dir):
        # Skip any folder that starts with an underscore
        dirnames[:] = [d for d in dirnames if not d.startswith("_")]
        
        # content += f"## {dirpath}\n\n"

        # Check if the directory has any .sql files
        sql_files = [f for f in filenames if f.lower().endswith(".sql")]

        if sql_files:
            # Remove the base directory path to make it relative to current_dir
            relative_path = os.path.relpath(dirpath, current_dir)
            depth = relative_path.count(os.sep)

            # For first-level subdirectories (e.g., "conv"), use ## heading
            if depth == 0:
                content += f"## {relative_path.replace(os.sep, '\\\\').lower()}\n\n"
            # For deeper subfolders (e.g., "conv/case"), use ### heading
            elif depth == 1:
                content += f"### {relative_path.replace(os.sep, '\\\\').lower()}\n\n"

            # Add a table for the scripts inside this folder
            content += "| Script Name |\n"
            content += "|-------------|\n"
            for file in sorted(sql_files):
                content += f"| {file} |\n"
            content += "\n"  # Space between sections for clarity

    return content

if __name__ == "__main__":
    # Define the root SQL directory
    sql_dir = "sql"  # Adjust this path if necessary
    generate_system_readmes(sql_dir)
