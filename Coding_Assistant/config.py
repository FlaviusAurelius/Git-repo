# Since we are using a free-tier gemini model, avoid wasting tokens by implementing a hard limit for file read
MAX_CHARS = 10000
# Hardcode relative directory to prevent GEMINI from reading files outside this directory, can be modified to accomodate changes
WORKING_DIR = "./calculator"