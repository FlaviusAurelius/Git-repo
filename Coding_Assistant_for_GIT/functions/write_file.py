import os
from google.genai import types

def write_file(working_directory, file_path, content):
    full_path = os.path.join(working_directory, file_path)
    
    abs_target_path = os.path.abspath(full_path)
    abs_working_directory = os.path.abspath(working_directory)
    
    if not(abs_target_path.startswith(abs_working_directory)):
        #print(f'Error: Cannot write to "{file_path}" as it is outside the permitted working directory')
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