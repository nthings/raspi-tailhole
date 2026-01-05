#!/bin/bash
set -e

echo "###########################################"
echo "#             Installing Go               #"
echo "###########################################"

# Get ARCH from the local script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ARCH=$(bash "$SCRIPT_DIR/get_arch.sh")

echo "Detected architecture: $ARCH"

#setting up go
echo "Setting up go..."
if [[ "$ARCH" == "amd64" ]]; then
    GO_TARBALL="go1.23.0.linux-amd64.tar.gz"
elif [[ "$ARCH" == "arm64" ]]; then
    GO_TARBALL="go1.23.0.linux-arm64.tar.gz"
elif [[ "$ARCH" == "armhf" ]]; then
    GO_TARBALL="go1.23.0.linux-armv6l.tar.gz"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi
wget "https://go.dev/dl/$GO_TARBALL"
sudo tar -C /usr/local -xzf "$GO_TARBALL"
rm "$GO_TARBALL"
# Add Go to PATH if not already present
if ! grep -q '/usr/local/go/bin' ~/.profile; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
fi
export PATH=$PATH:/usr/local/go/bin

echo "Go installation complete. Version:"
go version
