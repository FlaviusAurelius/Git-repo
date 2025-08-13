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
- Finally, add your Gemini API key to the .env file, which should look like this when you clone the repository.

## How to play around with this project?
-  To start, try:
```
  uv run main.py
```
