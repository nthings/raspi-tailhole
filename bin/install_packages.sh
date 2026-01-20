#!/bin/bash
set -e

echo "###########################################"
echo "#        Installing additional packages   #"
echo "###########################################"

sudo apt update
sudo apt install -y \
    at \
    sudo

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Install go
echo "Installing go"
bash "$SCRIPT_DIR/install_go.sh"

# Check if we already have docker group access
if ! groups | grep -q docker; then
    echo "Installing docker"
    # Install Docker
    bash "$SCRIPT_DIR/install_docker.sh"
    
    # Re-execute this script with docker group
    exec sg docker "$0"
fi
