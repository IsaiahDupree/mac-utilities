#!/bin/bash
# Re-enable sleep features on Mac
# This script restores normal sleep behavior

echo "Re-enabling sleep features on Mac..."
echo ""

# Check if running with sudo (required for pmset changes)
if [ "$EUID" -ne 0 ]; then 
    echo "Note: Some changes require administrator privileges."
    echo "You may be prompted for your password."
    echo ""
fi

# Restore default sleep settings
echo "Restoring default sleep settings..."

# Enable sleep on battery power (10 minutes default)
echo "Enabling sleep on battery power (10 minutes)..."
sudo pmset -b sleep 10

# Enable sleep when plugged in (10 minutes default)
echo "Enabling sleep when plugged in (10 minutes)..."
sudo pmset -c sleep 10

# Enable system sleep
echo "Enabling system sleep..."
sudo pmset -a disablesleep 0

# Allow idle sleep
echo "Allowing idle sleep..."
sudo pmset -a sleep 10

# Enable display sleep (5 minutes default)
echo "Enabling display sleep (5 minutes)..."
sudo pmset -a displaysleep 5

# Allow disk sleep (10 minutes default)
echo "Allowing disk sleep (10 minutes)..."
sudo pmset -a disksleep 10

# Enable hibernation (mode 3 = safe sleep)
echo "Enabling hibernation..."
sudo pmset -a hibernatemode 3

# Enable automatic restart on power loss
echo "Enabling automatic restart on power loss..."
sudo pmset -a autorestart 1

# Enable wake on network access
echo "Enabling wake on network access..."
sudo pmset -a womp 1

# Enable wake on lid open
echo "Enabling wake on lid open..."
sudo pmset -a lidwake 1

echo ""
echo "Current sleep settings:"
pmset -g
echo ""
echo "✓ Sleep features have been re-enabled with default settings!"
echo ""
echo "You can customize these settings in System Preferences > Energy Saver"
echo "Or use 'pmset -g' to view current settings"
