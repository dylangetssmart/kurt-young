import subprocess
import os
from .logger import log_message

def run_sql_script(script_path: str, server: str, database: str, log_dir: str, datetime_str: str):
    script_name = os.path.basename(script_path)
    output_file_path = os.path.join(log_dir, f'{script_name}_{datetime_str}.out')
    
    try:
        result = subprocess.run(
            ['sqlcmd', '-S', server, '-E', '-d', database, '-i', script_path, '-b', '-h', '-1'],
            capture_output=True, text=True, check=True
        )
        
        print(f'SUCCESS - {script_name}')
        log_message(os.path.join(log_dir, f'error_log_{datetime_str}.txt'), f'SUCCESS - {script_name}')
        log_message(os.path.join(log_dir, f'error_log_{datetime_str}.txt'), f'    Timestamp: {datetime_str}')
        if result.stdout:
            log_message(os.path.join(log_dir, f'error_log_{datetime_str}.txt'), f'\n{result.stdout}')
        log_message(os.path.join(log_dir, f'error_log_{datetime_str}.txt'), '---------------------------------------------------------------------------------------')
    except subprocess.CalledProcessError as e:
        error_output = e.stdout + e.stderr if e.stdout or e.stderr else str(e)
        
        log_message(os.path.join(log_dir, f'error_log_{datetime_str}.txt'), f'FAIL - {script_name}')
        log_message(os.path.join(log_dir, f'error_log_{datetime_str}.txt'), f'    Timestamp: {datetime_str}')
        log_message(os.path.join(log_dir, f'error_log_{datetime_str}.txt'), f'    Output File: {output_file_path}')
        
        with open(output_file_path, 'w') as output_file:
            output_file.write(error_output)
        print(f'FAIL - {script_name}')
