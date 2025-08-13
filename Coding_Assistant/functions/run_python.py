import os
import subprocess
from google.genai import types

def run_python_file(working_directory, file_path, args=[]):
    full_path = os.path.join(working_directory, file_path)
    
    abs_target_path = os.path.abspath(full_path)
    abs_working_directory = os.path.abspath(working_directory)
    
    # if target path is outside working directory, error
    if not(abs_target_path.startswith(abs_working_directory)):
        print(f'Error: Cannot execute "{file_path}" as it is outside the permitted working directory')
        return f'Error: Cannot execute "{file_path}" as it is outside the permitted working directory'
    # if target path doesn't exist, meaning there's no such file, error
    if not (os.path.exists(abs_target_path)):
        print(f'Error: File "{file_path}" not found.')
        return f'Error: File "{file_path}" not found.'
    # if target file is not a python file, error
    if not abs_target_path.endswith(".py"):
        print(f'Error: "{file_path}" is not a Python file.')
        return f'Error: "{file_path}" is not a Python file.'

    try:
        result = subprocess.run(
            ["python3", abs_target_path] + args,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            cwd=abs_working_directory,
            timeout=30,
            text=True,
            check=True
        )
    except Exception as run_ex:
        print(f"Error: executing Python file: {run_ex}")
        return f"Error: executing Python file: {run_ex}"
    except TimeoutError:
        print(f"Error: execution timeout")
        return f"Error: execution timeout"
    except PermissionError:
        print(f"Error: Insufficient permission to execute")
        return f"Error: Insufficient permission to execute"
    else:
        if result.stdout == "" and result.stderr == "":
            print(f"No output produced.")
            return f"No output produced."
        else:
            print(f"STDOUT: {result.stdout}")
            print(f"STDERR: {result.stderr}")
            if(result.returncode):
                print(f"Process exited with code {result.returncode}")
                
schema_run_python = types.FunctionDeclaration(
    name="run_python_file",
    description="Spawns a new process that executes the specified python file, constrained to the working directory.",
    parameters=types.Schema(
        type=types.Type.OBJECT,
        properties={
            "file_path": types.Schema(
                type=types.Type.STRING,
                description="The directory and name of the specified python files where it can be located, relative to the working directory.",
            ),
            "args": types.Schema(
                type=types.Type.ARRAY,
                items=types.Schema(
                    type=types.Type.STRING,
                    description="User supplied optional command line arguments to pass to the Python file.",
                ),
                description="User supplied optional command arguments to pass to the Python file.",
            ),
        },
        required=["file_path"],
    ),
)

    
# example code to initialize a thread in python and set the main thread to self terminate in some predetermined time
# from threading import Thread
# from time import sleep


# def func():
#     # CODE HERE
#     ...


# t = Thread(target=func, daemon=True)
# t.start()

# exit_timer = 4
# sleep(exit_timer)