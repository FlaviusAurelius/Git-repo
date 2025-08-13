import os
import sys
from google import genai
from google.genai import types
from sys_prompts import system_prompt
from function_schema import available_functions
from functions.calling_function import call_function

def main():
    # check if user requested verbose output and Process user input
    verbose = "--verbose" in sys.argv
    args = []
    for arg in sys.argv[1:]:
        if not arg.startswith("--"):
            args.append(arg)

    if not args:
        print("This is your AI code assistant")
        print('Sample Usage: python main.py "Fill your prompt here" [--verbose]')
        print('Example: python main.py "Help me build ___ app?"')
        sys.exit(1)
    
    user_prompt = " ".join(args)
    
    # set up gemini API, which should be in a .env file
    api_key = os.environ.get("GEMINI_API_KEY")
    client = genai.Client(api_key=api_key)


    if verbose:
        print(f"User prompt: {user_prompt}\n")
    
    # For initial message for AI model
    messages = [
        types.Content(role="user", parts=[types.Part(text=user_prompt)]),    
    ]
    response_obj, function_result = content_generation(client, messages, verbose)

    
    
    times_run = 0
    # for now, hard code iteration to 10 times to avoid wasting tokens
    while (times_run < 10):
        messages.append(response_obj.candidates[0].content)
        messages.extend(function_result)
        try:
            response_obj, function_result = content_generation(client, messages, verbose)
        except Exception as e:
            print(f"Error! {e}")
            break

        if not function_result:
            #print(f"Final Response: \n{response_obj.text}")
            break
        times_run+=1

# Form the request for gemini AI and process the output into human readable format
def content_generation(client, messages, verbose):
    response = client.models.generate_content(
        model="gemini-2.0-flash-001",
        contents=messages,
        config=types.GenerateContentConfig(
            tools=[available_functions], system_instruction=system_prompt
        ),
    )
    if verbose:
        print("Prompt tokens:", response.usage_metadata.prompt_token_count)
        print("Response tokens:", response.usage_metadata.candidates_token_count)

    function_results = []
    if not response.function_calls:
        return response, function_results
    
    for function_call_part in response.function_calls:
        try:
            function_call_result = call_function(function_call_part, verbose)
        except Exception as e:
            print(f"Error: {e}") # Or raise
            return None, []  

        if not function_call_result or not function_call_result.parts[0].function_response.response:
            raise Exception("Empty function call result")

        if verbose:
            print(f"Here's output--> {function_call_result.parts[0].function_response.response}")
        function_results.append(function_call_result)  # Collect all output by model
            
    return response, function_results