#!/bin/bash
set -e

echo "###########################################"
echo "#        Enable Ip Forwarding             #"
echo "###########################################"

# Check if /etc/sysctl.d directory exists
if [ -d "/etc/sysctl.d" ]; then
    # Enable IP forwarding using /etc/sysctl.d/99-tailscale.conf
    echo "Enabling IP forwarding with /etc/sysctl.d/99-tailscale.conf..."
    
    # Only add settings if they don't already exist
    if ! grep -q "net.ipv4.ip_forward = 1" /etc/sysctl.d/99-tailscale.conf 2>/dev/null; then
        echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
    else
        echo "IPv4 forwarding already configured"
    fi
    
    if ! grep -q "net.ipv6.conf.all.forwarding = 1" /etc/sysctl.d/99-tailscale.conf 2>/dev/null; then
        echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
    else
        echo "IPv6 forwarding already configured"
    fi
    
    sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
else
    # Enable IP forwarding using /etc/sysctl.conf
    echo "Enabling IP forwarding with /etc/sysctl.conf..."
    
    # Only add settings if they don't already exist
    if ! grep -q "net.ipv4.ip_forward = 1" /etc/sysctl.conf 2>/dev/null; then
        echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
    else
        echo "IPv4 forwarding already configured"
    fi
    
    if ! grep -q "net.ipv6.conf.all.forwarding = 1" /etc/sysctl.conf 2>/dev/null; then
        echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
    else
        echo "IPv6 forwarding already configured"
    fi
    
    sudo sysctl -p /etc/sysctl.conf
fi

echo "###########################################"
echo "-------------------------------------------"