import os
from google.genai import types

def get_files_info(working_directory, directory="."):
    full_path = os.path.join(working_directory, directory)
    
    abs_target_directory = os.path.abspath(full_path)
    abs_working_directory = os.path.abspath(working_directory)

    # print(f"full path: {full_path}")
    # print(f"working directory: {working_directory}" )
    # print(f"target directory: {directory}","\n" )
    # print(f"absolute target directory path: {abs_directory}")
    # print(f"absolute working directory path: {abs_working_directory}")
    
    ##  1. If the absolute path to the directory is outside the working_directory, return a string error message:
    if not(abs_target_directory.startswith(abs_working_directory)):
        print(f"Error: Cannot list '{directory}' as it is outside the permitted working directory")
        return f"Error: Cannot list '{directory}' as it is outside the permitted working directory"
    ##  2. If the directory argument is not a directory, again, return an error string:
    if not(os.path.isdir(abs_target_directory)):
        print(f'Error: "{directory}" is not a directory')
        return f'Error: "{directory}" is not a directory'
    ##  3. Build and return a string representing the contents of the directory. It should use this format:
    # else:
    #     all_items = os.listdir(abs_target_directory)
    #     for item in all_items:
    #         # first add the path to each item in order for function to work
    #         item_path = os.path.join(abs_target_directory, item)
    #         print(f"{item}: file_size={os.path.getsize(item_path)}, is_dir={not os.path.isfile(item_path)}")
    try:
        files_info = []
        for filename in os.listdir(abs_target_directory):
            filepath = os.path.join(abs_target_directory, filename)
            file_size = 0
            is_dir = os.path.isdir(filepath)
            file_size = os.path.getsize(filepath)
            files_info.append(
                f"- {filename}: file_size={file_size} bytes, is_dir={is_dir}"
            )
        # print(files_info)
        return "\n".join(files_info)
    except Exception as e:
        print(f"Error listing files: {e}")
        return f"Error listing files: {e}"
    

schema_get_files_info = types.FunctionDeclaration(
    name="get_files_info",
    description="Lists files in the specified directory along with their sizes, constrained to the working directory.",
    parameters=types.Schema(
        type=types.Type.OBJECT,
        properties={
            "directory": types.Schema(
                type=types.Type.STRING,
                description="The directory to list files from, relative to the working directory. If not provided, lists files in the working directory itself.",
            ),
        },
    ),
)


        
# get_files_info("calculator", ".")
# get_files_info("calculator", "pkg")
# get_files_info("calculator", "/bin")
# get_files_info("calculator", "../")

# try:
    #     print()
    # except Exception as e:
    #     print(f"Error: Cannot list '{directory}' as it is outside the permitted working directory")