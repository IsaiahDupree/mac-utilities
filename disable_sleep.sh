#!/bin/bash
# Disable sleep features on Mac
# This script prevents your Mac from sleeping, both on battery and when plugged in

echo "Disabling sleep features on Mac..."
echo ""

# Check if running with sudo (required for pmset changes)
if [ "$EUID" -ne 0 ]; then 
    echo "Note: Some changes require administrator privileges."
    echo "You may be prompted for your password."
    echo ""
fi

# Save current settings to a backup file
BACKUP_FILE="$HOME/.mac_sleep_settings_backup.txt"
echo "Saving current sleep settings to: $BACKUP_FILE"
pmset -g > "$BACKUP_FILE" 2>/dev/null || echo "Could not save backup (this is okay)"

# Disable sleep on battery power (0 = never)
echo "Disabling sleep on battery power..."
sudo pmset -b sleep 0

# Disable sleep when plugged in (0 = never)
echo "Disabling sleep when plugged in..."
sudo pmset -c sleep 0

# Disable system sleep
echo "Disabling system sleep..."
sudo pmset -a disablesleep 1

# Prevent idle sleep
echo "Preventing idle sleep..."
sudo pmset -a sleep 0

# Disable display sleep (optional - uncomment if you want displays to stay on)
# echo "Disabling display sleep..."
# sudo pmset -a displaysleep 0

# Prevent disk sleep
echo "Preventing disk sleep..."
sudo pmset -a disksleep 0

# Disable hibernation
echo "Disabling hibernation..."
sudo pmset -a hibernatemode 0

# Prevent automatic restart on power loss
echo "Preventing automatic restart on power loss..."
sudo pmset -a autorestart 0

# Disable wake on network access
echo "Disabling wake on network access..."
sudo pmset -a womp 0

# Disable wake on lid open (if applicable)
echo "Disabling wake on lid open..."
sudo pmset -a lidwake 0

echo ""
echo "Current sleep settings:"
pmset -g
echo ""
echo "✓ Sleep features have been disabled!"
echo ""
echo "To re-enable sleep, run: ./enable_sleep.sh"
echo "Or restore from backup: cat $BACKUP_FILE"
