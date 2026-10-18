#!/bin/bash
# Restart Immersed app with a 2-minute delay

APP_NAME="Immersed"
DELAY_SECONDS=120  # 2 minutes

echo "Restarting $APP_NAME with a 2-minute delay..."

# Step 1: Quit the app
echo "Step 1: Quitting $APP_NAME..."
if pgrep -f "$APP_NAME" > /dev/null; then
    osascript -e "tell application \"$APP_NAME\" to quit" 2>/dev/null || true
    
    # Wait for the app to fully quit
    while pgrep -f "$APP_NAME" > /dev/null; do
        sleep 0.5
    done
    echo "$APP_NAME has been quit."
else
    echo "$APP_NAME is not currently running."
fi

# Step 2: Wait 2 minutes
echo "Step 2: Waiting 2 minutes before relaunching..."
echo "  (This will take $DELAY_SECONDS seconds)"
for i in {1..120}; do
    remaining=$((DELAY_SECONDS - i))
    if [ $((i % 10)) -eq 0 ] || [ $remaining -lt 10 ]; then
        echo "  $remaining seconds remaining..."
    fi
    sleep 1
done

# Step 3: Launch the app
echo "Step 3: Launching $APP_NAME..."
open -a "$APP_NAME" 2>/dev/null || {
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
echo "Done! $APP_NAME has been restarted."





