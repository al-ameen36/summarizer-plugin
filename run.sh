#!/bin/bash

# Comprehensive FastAPI Project Setup and Run Script

# Configuration
PROJECT_NAME="fastapi_project"
VENV_NAME="venv"
HOST="127.0.0.1"
PORT="8000"
FILE_NAME="main.py"
REQUIREMENTS_FILE="requirements.txt"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Error handling function
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Check if Python is installed
check_python() {
    if ! command -v python &> /dev/null
    then
        error_exit "Python is not installed. Please install it first."
    fi
}

# Create virtual environment
create_venv() {
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python -m venv $VENV_NAME || error_exit "Failed to create virtual environment"
}


# Activate virtual environment
activate_venv() {
    echo -e "${YELLOW}Activating virtual environment...${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* || "$OSTYPE" == "darwin"* ]]; then
        # Linux or macOS
        source $VENV_NAME/bin/activate || error_exit "Failed to activate virtual environment"
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows (Git Bash, MinGW, or CMD)
        source $VENV_NAME/Scripts/activate || error_exit "Failed to activate virtual environment"
    else
        error_exit "Unsupported operating system: $OSTYPE"
    fi
}

# Install dependencies
install_dependencies() {
    # Check if requirements.txt exists
    if [ ! -f "$REQUIREMENTS_FILE" ]; then
        echo -e "${YELLOW}Creating requirements.txt...${NC}"
        touch $REQUIREMENTS_FILE
        echo "fastapi" >> $REQUIREMENTS_FILE
        echo "uvicorn" >> $REQUIREMENTS_FILE
    fi

    echo -e "${YELLOW}Installing dependencies...${NC}"
    pip install -r $REQUIREMENTS_FILE || error_exit "Failed to install dependencies"
}

# Run the FastAPI application
run_fastapi() {
    echo -e "${GREEN}Starting FastAPI application...${NC}"
    fastapi run "$FILE_NAME" --host "$HOST" --port "$PORT"
}

# Main script execution
main() {
    # Check and set up project
    check_python
    
    # If venv doesn't exist, create it
    if [ ! -d "$VENV_NAME" ]; then
        create_venv
    fi

    # Activate virtual environment
    activate_venv

    # Prepare environment
    install_dependencies

    # Run the application
    run_fastapi

    # Deactivate virtual environment when done
    deactivate
}

# Run the main function
main