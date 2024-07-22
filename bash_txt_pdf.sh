#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 input.txt output.pdf"
    exit 1
}

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    usage
fi

# Assign input arguments to variables
input_file=$1
output_file=$2

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found!"
    exit 1
fi

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null
then
    echo "pandoc could not be found"
    echo "Installing pandoc..."

    # Detect OS and install pandoc accordingly
    if [ "$(uname)" == "Darwin" ]; then
        # MacOS
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Please install Homebrew first."
            exit 1
        fi
        brew install pandoc
    elif [ -f /etc/debian_version ]; then
        # Debian-based Linux
        sudo apt update
        sudo apt install -y pandoc
    elif [ -f /etc/redhat-release ]; then
        # RedHat-based Linux
        sudo yum install -y pandoc
    else
        echo "Unsupported OS. Please install pandoc manually."
        exit 1
    fi
fi

# Convert txt to pdf using pandoc
pandoc "$input_file" -o "$output_file"

# Check if the conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion completed: $output_file"
else
    echo "Conversion failed."
    exit 1
fi
