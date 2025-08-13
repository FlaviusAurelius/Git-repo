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

    # print(f"Debug init input 1: {client}")
    print(f"Debug init input: {messages}\n")
    # print(f"Debug init input 3: {verbose}")
    # Function inputs
    response_obj, function_result = content_generation(client, messages, verbose)
    #Time to understand output
    # for index, candidate in enumerate(response.candidates):
    #     print(f"Candidated {index}: {candidate.content}")
    #     for p_in, part in enumerate(candidate.content.parts):
    #         print(f"part {p_in}: {part}")
    
    times_run = 0
    while (times_run < 10):
        # add the output of the conversation and then function output to the message
        # print(f"loop {times_run}\n")
        # if response object is not empty/None

        messages.append(response_obj.candidates[0].content)
        messages.extend(function_result)
        # print(f"\nLooped Debug init input 1: {client}\n")
        # print(f"\nLooped Debug init input 2: {messages}\n")
        # print(f"\nLooped Debug init input 3: {verbose}\n")
        try:
            response_obj, function_result = content_generation(client, messages, verbose)
        except Exception as e:
            # print(f"Query Response: \n{response_obj}")
            # print(f"Function output: \n{function_result}")
            print(f"Error!!! {e}")
            break
        # If we got the model's response text, the task is complete
        if not function_result:
            print(f"Final Response: \n{response_obj.text}")
            break
        times_run+=1
    # print()
    # for num, msg in enumerate(messages):
    #     print(f"Here's message no.{num}: msg")
    # old code went here
    
def content_generation(client, messages, verbose):
    # print(f"generating content using: \n {client} \n {messages} \n {verbose}")

    response = client.models.generate_content(
        model="gemini-2.0-flash-001",
        contents=messages,
        config=types.GenerateContentConfig(
            tools=[available_functions], system_instruction=system_prompt
        ),
            # config = types.GenerateContentConfig(system_instruction=system_prompt),
    )
    if verbose:
        print("Prompt tokens:", response.usage_metadata.prompt_token_count)
        print("Response tokens:", response.usage_metadata.candidates_token_count)
    
    # print(f" \n Here's .candidate 0: {response.candidates[0].content.parts[0].text} ")
    # print("Response:")
    # print(response.text)
    function_results = []
    if not response.function_calls:
        # print(f"\n  Here's .candidate: {response.candidates} \n")
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

            function_results.append(function_call_result)  # Collect all
    # Don't return response if no function is being called, placeholder measure
    return response, function_results
            


# def content_generation(client, messages, verbose):
    
#     # print(f"generating content using: \n {client} \n {messages} \n {verbose}")

#     response = client.models.generate_content(
#         model="gemini-2.0-flash-001",
#         contents=messages,
#         config=types.GenerateContentConfig(
#             tools=[available_functions], system_instruction=system_prompt
#         ),
#             # config = types.GenerateContentConfig(system_instruction=system_prompt),
#     )

#     # print("checking verbosity")
#     if verbose:
#         print("Prompt tokens:", response.usage_metadata.prompt_token_count)
#         print("Response tokens:", response.usage_metadata.candidates_token_count)
    
#     print(f" \n Here's .candidate 0: {response.candidates[0].content.parts[0].text} ")
#     print("Response:")
#     # print(response.text)
#     if not response.function_calls:
#         print(f"\n  Here's .candidate: {response.candidates} \n")
#         return response.text
    
    
#     for function_call_part in response.function_calls:
#         # print(f"Calling function: {function_call_part.name}({function_call_part.args})")    
#         function_call_result = call_function(function_call_part, verbose)
        
#         if not (function_call_result.parts[0].function_response.response):
#             raise TypeError(f"Content object is not subscriptable")
#         elif (function_call_result.parts[0].function_response.response) and verbose:
#             print(f"-> {function_call_result.parts[0].function_response.response}")



if __name__ == "__main__":
    main()


# old code here
# # if user wants more context 
    # if (len(u_input) > 2 and u_input[2] == "--verbose"):
        
    #     response = client.models.generate_content(
    #         model="gemini-2.0-flash-001",
    #         contents=messages,
    #         config = types.GenerateCOntentConfig(system_instruction=system_prompt),
    #     )
    #     print(response.text)
    #     print("User prompt:", u_input[1])
    #     print("Prompt tokens:", response.usage_metadata.prompt_token_count )
    #     print("Response tokens:", response.usage_metadata.candidates_token_count )
    # else:
    #     response = client.models.generate_content(
    #         model="gemini-2.0-flash-001",
    #         contents=messages,
    #         config = types.GenerateCOntentConfig(system_instruction=system_prompt),
    #     )
    #     print(response.text)



### lesson 3 and 4 start
# response = client.models.generate_content(
#     model="gemini-2.0-flash-001", contents="Why is Boot.dev such a great place to learn backend development? Use one paragraph maximum."
# )
# print(response.text)

# response = client.models.generate_content(
#     model="gemini-2.0-flash-001", contents=u_input[1],
# )
# print(response.text)

# print("Prompt tokens:", response.usage_metadata.prompt_token_count )
# print("Response tokens:", response.usage_metadata.candidates_token_count )

### lesson 3 and 4 end