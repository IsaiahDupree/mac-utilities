#!/bin/bash
# Restart Immersed app (NOT the Mac - only the app)

APP_NAME="Immersed"

echo "Restarting $APP_NAME app (this will NOT restart your Mac)..."
echo ""

# Check if the app is running and quit it
if pgrep -f "$APP_NAME" > /dev/null; then
    echo "Step 1: Quitting $APP_NAME..."
    osascript -e "tell application \"$APP_NAME\" to quit" 2>/dev/null || true
    
    # Wait for the app to fully quit (with timeout)
    timeout=10
    elapsed=0
    while pgrep -f "$APP_NAME" > /dev/null && [ $elapsed -lt $timeout ]; do
        sleep 0.5
        elapsed=$((elapsed + 1))
    done
    
    if pgrep -f "$APP_NAME" > /dev/null; then
        echo "  App didn't quit gracefully, force quitting..."
        pkill -9 -f "$APP_NAME" 2>/dev/null || true
        sleep 1
    fi
    echo "  $APP_NAME has been quit."
else
    echo "Step 1: $APP_NAME is not currently running."
fi

# Wait a moment before launching
sleep 1

# Launch the app
echo "Step 2: Launching $APP_NAME..."
open -a "$APP_NAME" 2>/dev/null || {
    # Try alternative launch methods
    if [ -d "/Applications/Immersed.app" ]; then
        open "/Applications/Immersed.app"
    elif [ -d "$HOME/Applications/Immersed.app" ]; then
        open "$HOME/Applications/Immersed.app"
    else
        echo "Error: Could not find $APP_NAME. Please check if it's installed."
        exit 1
    fi
}

echo ""
echo "Done! $APP_NAME app has been restarted (your Mac was NOT restarted)."





