import os
from google.genai import types
from config import MAX_CHARS

def get_file_content(working_directory, file_path):    
    full_path = os.path.join(working_directory, file_path)
    
    abs_file_path = os.path.abspath(full_path)
    abs_working_path = os.path.abspath(working_directory)
    
    ##  1. if the file_path is outside the working_directory, return a string with an error:
    if not(abs_file_path.startswith(abs_working_path)):
        return f'Error: Cannot read "{file_path}" as it is outside the permitted working directory'
    ##  2. If the file_path is not a file, again, return an error string:
    elif not os.path.isfile(abs_file_path):
        return f'Error: File not found or is not a regular file: "{file_path}"'
    ##  3. Read the file and return its contents as a string
    else:
        # set up try to catch error if file couldn't be opened or file doesn't exist
        try: 
            with open(abs_file_path, "r") as file:
                file_content_string = file.read(MAX_CHARS)
        except Exception as open_error:
            print(f"Failed to open '{file_path}', error {open_error}")
            return f"Failed to open '{file_path}', error {open_error}"
        except PermissionError:
            print(f"Permission denied accessing '{file_path}'")
            return f"Permission denied accessing '{file_path}'"
        else:
            # if exceeds MAX_CHARS, truncate
            # print(file_content_string)
            if os.path.getsize(abs_file_path) > MAX_CHARS:
                print(f'{file_content_string}\n[File "{file_path}" truncated at {MAX_CHARS} characters]')
                return f'{file_content_string}\n[File "{file_path}" truncated at {MAX_CHARS} characters]'
            return file_content_string

schema_get_file_content = types.FunctionDeclaration(
    name="get_file_content",
    description="Read and retrieve specific file in the specified directory, constrained to the working directory.",
    parameters=types.Schema(
        type=types.Type.OBJECT,
        properties={
            "file_path": types.Schema(
                type=types.Type.STRING,
                description="The directory where the specified files can be located, relative to the working directory.",
            ),
        },
        required=["file_path"],
    ),
)
