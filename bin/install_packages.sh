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

# Install docker
echo "Installing docker"
bash "$SCRIPT_DIR/install_docker.sh"
