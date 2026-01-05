#!/bin/bash
set -e

# Function to detect the architecture
get_architecture() {
    ARCHITECTURE=$(uname -m)

    if [[ "$ARCHITECTURE" == "x86_64" ]]; then
        ARCH="amd64"
    elif [[ "$ARCHITECTURE" == "aarch64" || "$ARCHITECTURE" == "arm64" ]]; then
        ARCH="arm64"
    elif [[ "$ARCHITECTURE" == "armv7l" || "$ARCHITECTURE" == "armv6l" ]]; then
        ARCH="armhf"
    else
        echo "Unsupported architecture: $ARCHITECTURE" >&2
        exit 1
    fi
    # This sends the string to the script that called it
    echo "$ARCH"
}

# Execute the function and print the result
get_architecture