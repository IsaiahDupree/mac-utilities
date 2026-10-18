#!/bin/bash
# Reset Immersed app - Force quit, clear cache, and restart

APP_NAME="Immersed"
APP_BUNDLE="Immersed.app"

echo "Resetting $APP_NAME..."

# Step 1: Force quit all Immersed processes
echo "Step 1: Force quitting all $APP_NAME processes..."
pkill -9 -f "$APP_NAME" 2>/dev/null || true

# Also try using osascript to quit gracefully first, then force
osascript -e "tell application \"$APP_NAME\" to quit" 2>/dev/null || true
sleep 1

# Force kill any remaining processes
pkill -9 -f "$APP_NAME" 2>/dev/null || true

# Wait for processes to fully terminate
sleep 2

# Step 2: Clear cache and temporary files
echo "Step 2: Clearing cache and temporary files..."

# Common cache locations for macOS apps
CACHE_DIRS=(
    "$HOME/Library/Caches/com.immersed.Immersed"
    "$HOME/Library/Caches/Immersed"
    "$HOME/Library/Application Support/Immersed/Cache"
    "$HOME/Library/Application Support/Immersed/cache"
    "$HOME/Library/Containers/com.immersed.Immersed/Data/Library/Caches"
    "$HOME/Library/Saved Application State/com.immersed.Immersed.savedState"
)

for dir in "${CACHE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  Removing: $dir"
        rm -rf "$dir" 2>/dev/null || true
    fi
done

# Step 3: Clear preferences (optional - uncomment if you want to reset settings)
# echo "Step 3: Clearing preferences..."
# PREF_FILES=(
#     "$HOME/Library/Preferences/com.immersed.Immersed.plist"
#     "$HOME/Library/Preferences/Immersed.plist"
# )
# 
# for pref in "${PREF_FILES[@]}"; do
#     if [ -f "$pref" ]; then
#         echo "  Removing: $pref"
#         rm -f "$pref" 2>/dev/null || true
#     fi
# done

# Step 4: Wait a moment
sleep 1

# Step 5: Launch the app fresh
echo "Step 5: Launching $APP_NAME..."
open -a "$APP_NAME" 2>/dev/null || {
    # Try alternative launch methods if the app name doesn't work
    if [ -d "/Applications/$APP_BUNDLE" ]; then
        open "/Applications/$APP_BUNDLE"
    elif [ -d "$HOME/Applications/$APP_BUNDLE" ]; then
        open "$HOME/Applications/$APP_BUNDLE"
    else
        echo "Error: Could not find $APP_NAME. Please check if it's installed."
        exit 1
    fi
}

echo ""
echo "Reset complete! $APP_NAME has been restarted with cleared cache."





