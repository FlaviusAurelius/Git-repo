import os
from google.genai import types

def write_file(working_directory, file_path, content):
    full_path = os.path.join(working_directory, file_path)
    
    abs_target_path = os.path.abspath(full_path)
    abs_working_directory = os.path.abspath(working_directory)
    
    if not(abs_target_path.startswith(abs_working_directory)):
        print(f'Error: Cannot write to "{file_path}" as it is outside the permitted working directory')
        return f'Error: Cannot write to "{file_path}" as it is outside the permitted working directory'
    
    if not os.path.exists(abs_target_path):
        try:
            os.makedirs(os.path.dirname(abs_target_path), exist_ok=True)
        except Exception as e:
            return f"Error: creating directory: {e}"
        
    if os.path.exists(abs_target_path) and os.path.isdir(abs_target_path):
        return f'Error: "{file_path}" is a directory, not a file'
    try:
        with open(abs_target_path, "w") as f:
            f.write(content)
        return (
            f'Successfully wrote to "{file_path}" ({len(content)} characters written)'
        )
    except Exception as e:
        return f"Error: writing to file: {e}"
    
schema_write_file = types.FunctionDeclaration(
    name="write_file",
    description="Writes specified content to specified file in specified location, constrained to the working directory.",
    parameters=types.Schema(
        type=types.Type.OBJECT,
        properties={
            "file_path": types.Schema(
                type=types.Type.STRING,
                description="The directory which contains the name where the specified content are to be written to, relative to the working directory. ",
            ),
            "content": types.Schema(
                type=types.Type.STRING,
                description="The content to write to file",
            ),
        },
        required=["file_path", "content"],
    ),
)    
    # def write_file(working_directory, file_path, content):
    #     abs_working_directory = os.path.abspath(working_directory)
    #     full_path = os.path.abspath(os.path.join(working_directory, file_path))
    #     if full_path.startswith(abs_working_directory) == False:
    #         return f'Error: Cannot write to "{file_path}" as it is outside the permitted working directory'
    #     try:
    #         os.makedirs(os.path.dirname(full_path), exist_ok=True)
    #     except Exception as e:
    #         return f"Error: {e}"
    #     try:
    #         with open(full_path, "w") as f:
    #             f.write(content)
    #             return f'Successfully wrote to "{file_path}" ({len(content)} characters written)'
    #     except Exception as e:
    #         return f"Error: {e}"
    
    # Old code
    # case to handle attempts to write to directory that doesn't exist yet
    # if target path is not a directory and also not a file, 
    #   create directory
    # if not(os.path.isdir(abs_target_path)) and not (os.path.isfile(abs_target_path)):
    #     try:
    #         os.makedirs(abs_target_path)
    #     except Exception as mkdir_e:
    #         print(f'Error: Cannot create directory "{file_path}" due to {mkdir_e}')
    #         return f'Error: Cannot create directory "{file_path}" due to {mkdir_e}'
    #     else:
    #         print(f'Directory {file_path} successfully created')
    #         return f'Directory {file_path} successfully created'
    
    # # if the file_path doesn't exist, create it. As always, if there are errors, 
    # #   return a string representing the error, prefixed with "Error:".
    #     # Case 2: Check if the target path is a directory
    # try:
    #     with open(abs_target_path, "w") as write_to_this:
    #         write_to_this.write(content)
    # except PermissionError:
    #     print(f'Error: Cannot write to "{file_path}" insufficient permission')
    #     return f'Error: Cannot write to "{file_path}", insufficient permission'
    # except Exception as write_ex:
    #     print(f'Error: Failed to write to "{file_path}" due to {write_ex}')
    #     return f'Error: Failed to write to "{file_path}" due to {write_ex}'
    # else:
    #     print(f'Successfully wrote to "{file_path}" ({len(content)} characters written)')
    #     return f'Successfully wrote to "{file_path}" ({len(content)} characters written)'