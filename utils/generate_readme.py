import os

def generate_readmes(sql_dir):
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
            content += "| Script Name |\n"
            content += "|-------------|\n"
            for sql_file in sorted(sql_files):
                content += f"| {sql_file} |\n"

            # Write the content to the README.md file
            with open(readme_path, "w", encoding="utf-8") as readme_file:
                readme_file.write(content)

            print(f"Created {readme_path}")

if __name__ == "__main__":
    # Define the root SQL directory
    sql_dir = "sql"
    generate_readmes(sql_dir)
