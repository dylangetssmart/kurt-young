import os

def extract_metadata_from_sql(file_path, keys):
    """
    Extract specified metadata from the comment block at the top of an SQL file.

    Args:
        file_path (str): Path to the SQL file.
        keys (list of str): List of metadata keys to extract (e.g., ['Author', 'Description']).

    Returns:
        dict: A dictionary with keys as metadata fields and their corresponding extracted values.
              If a key is not found, its value will be 'Not provided'.
    """
    metadata = {key: "Not provided" for key in keys}
    try:
        with open(file_path, "r", encoding="utf-8") as sql_file:
            lines = sql_file.readlines()
            for line in lines:
                for key in keys:
                    if f"{key}:" in line:
                        metadata[key] = line.split(f"{key}:", 1)[1].strip()
                        break
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    return metadata

def generate_readmes_for_sql_files(sql_dir):
    """
    Generate a README.md file in every directory that contains .sql files.

    Args:
        sql_dir (str): Path to the 'sql' directory.
    """
    # Walk through all directories starting from sql_dir
    for dirpath, _, filenames in os.walk(sql_dir):
        # Skip directories that start with an underscore
        if any(part.startswith("_") for part in dirpath.split(os.sep)):
            continue

        # Find all .sql files in the current directory
        sql_files = [f for f in filenames if f.lower().endswith(".sql")]

        # If the directory contains .sql files, create a README.md
        if sql_files:
            readme_path = os.path.join(dirpath, "README.md")
            relative_path = os.path.relpath(dirpath, sql_dir)

            # Generate content for the README.md file
            content = f"# {relative_path.replace(os.sep, ' ').title()}\n\n"
            content += "| Script Name | Description |\n"
            content += "|-------------|-------------|\n"
            for sql_file in sorted(sql_files):
                file_path = os.path.join(dirpath, sql_file)
                metadata = extract_metadata_from_sql(file_path, ["Description"])
                # metadata = extract_metadata_from_sql(file_path, ["Description", "Author", "Date"])
                content += f"| {sql_file} | {metadata['Description']} |\n"

            # Write the content to the README.md file
            with open(readme_path, "w", encoding="utf-8") as readme_file:
                readme_file.write(content)

            print(f"Created {readme_path}")

if __name__ == "__main__":
    # Define the root SQL directory
    sql_dir = "sql"  # Adjust this path if necessary
    generate_readmes_for_sql_files(sql_dir)
