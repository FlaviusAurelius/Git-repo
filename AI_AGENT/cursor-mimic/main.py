import os
import sys
from dotenv import load_dotenv
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
        print('Example: python main.py "How do I build a ___ app?"')
        sys.exit(1)
    
    user_prompt = " ".join(args)
    
    # set up gemini API
    api_key = os.environ.get("GEMINI_API_KEY")
    client = genai.Client(api_key=api_key)

    if verbose:
        print(f"User prompt: {user_prompt}\n")
    
    
    messages = [
        types.Content(role="user", parts=[types.Part(text=user_prompt)]),    
    ]

    print(f"Debug init input: {messages}\n")

    response_obj, function_result = content_generation(client, messages, verbose)

    # hard code no. iterations for now to avoid wasting tokens
    times_run = 0
    while (times_run < 20):
        messages.append(response_obj.candidates[0].content)
        messages.extend(function_result)
        try:
            response_obj, function_result = content_generation(client, messages, verbose)
        except Exception as e:
            print(f"Error!!! {e}")
            break
        # If we got the model's response text, the task is complete
        if not function_result:
            print(f"Final Response: \n{response_obj.text}")
            break
        times_run+=1
    
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
                print(f"Error: {e}")
                return None, []  # Or raise; but return empty for consistency

            if not function_call_result or not function_call_result.parts[0].function_response.response:
                raise Exception("Empty function call result")

            if verbose:
                print(f"Here's output--> {function_call_result.parts[0].function_response.response}")

            function_results.append(function_call_result)
    # Don't return response if no function is being called, placeholder measure
    return response, function_results


if __name__ == "__main__":
    main()
