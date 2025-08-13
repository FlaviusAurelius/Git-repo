# Coding Assistant

This is a simplified AI-driven tool to assist with coding tasks, debugging, and project management.

## Requirements
- Python 3.10+ installed
- [uv](https://github.com/astral-sh/uv) project and pacakge manager
- Access to unix-like shell, windows user should check out wsl [here](https://learn.microsoft.com/en-us/windows/wsl/install) which is what I used
- A google Gemini's API key which can be obtained for free, check the link [here](https://aistudio.google.com/welcome) for more information

## Setting up
- After you have uv installed, clone the repository (if you haven't already)
- Navigate to where **Coding_Assistant** is located on your system via your unix-like shell
- Create a virtual environment inside the project by doing the following:
```
  uv venv
  uv init --bare
```
- Then activate the virtual environment:
```
  source .venv/bin/activate
```
- Add the following dependency via the following command once the virtual environment is activated
```
  uv add google-genai==1.12.1
```
- Finally, add your Gemini API key to the .env file by overwriting inside the double quote, which should look like this when you clone the repository.
```
  GEMINI_API_KEY="OVERWRITE_THIS_WITH_API_KEY"
```
## How to play around with this project?
-  To start, try:
```
  uv run main.py
```
- Which will show you how you can call the coding assistant to do things, after that, this project is now your oyster. Have fun!

## Note:
- To change the generative AI's behavior, edit the `sys_prompt.py` file
- Since this project was developed and tested with the free-tier gemini model, the amount of data that could be read and fed to the model is hard-coded in `config.py`, feel free to change the number for your purpose
- `config.py` also hard-codes `./calculator` as the directory to operate in to prevent the AI from read/modify files outside in other places for your PC, this is important for security reason!!!. Nevertheless, feel free to modify it to suit your purpose, just remember that if changed, you should be careful with what you ask the AI to do.
- Also, feel free to modify/delete the entire `./calculator` directory, it is just a simple calculator program for this project to experiment with.