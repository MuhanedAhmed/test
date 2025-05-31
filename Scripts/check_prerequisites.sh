#!/bin/bash

# --------------------------------------------------------------------------------
# Script: check_prerequisites.sh
# Purpose: Ensure required CLI tools are installed before running the main script
# Author: Mohaned Ahmed
# --------------------------------------------------------------------------------

# Define color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 

# List of required commands
REQUIRED_COMMANDS=("aws" "terraform" "ssh" "scp")

# Function to check if a command exists
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${RED}"
        echo -e "ERROR: '$cmd' is not installed or not found in PATH."
        echo -e "${NC}"
        return 1
    else
        echo -e "${GREEN}"
        echo -e "'$cmd' is installed."
        echo -e "${NC}"
        return 0
    fi
}


echo -e "${BLUE}"
echo "Checking system prerequisites..."
echo -e "${NC}"

# Track overall status
ALL_OK=true

# Loop through each required command
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! check_command "$cmd"; then
        ALL_OK=false
    fi
done

# Final check
if [ "$ALL_OK" = false ]; then
    echo -e "${RED}"
    echo -e "One or more required tools are missing. Please install them before continuing."
    echo -e "${NC}"
    exit 1
else
    echo -e "${GREEN}"
    echo -e "All prerequisites are installed. Proceeding..."
    echo -e "${NC}"
    exit 0
fi
