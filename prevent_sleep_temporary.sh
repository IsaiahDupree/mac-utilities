#!/bin/bash
# Temporarily prevent sleep using caffeinate
# This keeps the Mac awake until the script is stopped (Ctrl+C)

echo "Preventing sleep temporarily..."
echo "Press Ctrl+C to stop and allow sleep again"
echo ""

# Prevent sleep indefinitely
# -i prevents idle sleep
# -d prevents display sleep
# -m prevents disk sleep
# -s prevents system sleep
# -u prevents sleep when user is active
# -w waits for the process to exit

caffeinate -i -d -m -s -u -w $$

echo ""
echo "Sleep prevention stopped."
