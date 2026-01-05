#!/bin/bash
set -e
: ${NETWORK_RANGE:?"ERROR: NETWORK_RANGE parameter is required Example: NETWORK_RANGE=192.168.1.0/24"}
: ${TS_API_CLIENT_ID:?"ERROR: TS_API_CLIENT_ID environment variable is required Set with: export TS_API_CLIENT_ID=your_client_id"}
: ${TS_API_CLIENT_SECRET:?"ERROR: TS_API_CLIENT_SECRET environment variable is required . Set with: export TS_API_CLIENT_SECRET=your_client_secret"}

# Parse command line arguments (override environment variable if provided)
for arg in "$@"; do
  case $arg in
    NETWORK_RANGE=*)
      NETWORK_RANGE="${arg#*=}"
      shift
      ;;
    *)
      # Unknown option
      ;;
  esac
done

echo "Using network CIDR: $NETWORK_RANGE"
export NETWORK_RANGE

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Enable VNC service
bash "$SCRIPT_DIR/enable_vnc.sh"

# Set static ip 
bash "$SCRIPT_DIR/set_static_ip.sh"

# Enable ip forwarding 
bash "$SCRIPT_DIR/enable_ip_forwarding.sh"

# Install additional dependencies
echo "Installing additional dependencies"
bash "$SCRIPT_DIR/install_packages.sh"

# Copy refresh_tailscale script to /var/opt
echo "###########################################"
echo "#         Refresh tailscale script        #"
echo "###########################################"
sudo mkdir -p /var/opt
echo "Copying refresh tailscale script"
sudo cp "$SCRIPT_DIR/refresh_tailscale.sh" /var/opt/refresh_tailscale.sh
sudo chmod +x /var/opt/refresh_tailscale.sh
bash /var/opt/refresh_tailscale.sh "$NETWORK_RANGE"
