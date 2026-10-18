#!/bin/bash

# Google Antigravity - Install to Dock Script
# This creates a Mac application bundle that can be added to the Dock

APP_NAME="Google Antigravity"
APP_DIR="$HOME/Applications"
APP_PATH="$APP_DIR/$APP_NAME.app"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Creating $APP_NAME application..."

# Create app bundle structure
mkdir -p "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/Resources"

# Create Info.plist
cat > "$APP_PATH/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>launch</string>
    <key>CFBundleIconFile</key>
    <string>icon.icns</string>
    <key>CFBundleIdentifier</key>
    <string>com.google.antigravity</string>
    <key>CFBundleName</key>
    <string>Google Antigravity</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.10</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

# Create launcher script
cat > "$APP_PATH/Contents/MacOS/launch" << 'LAUNCHER'
#!/bin/bash
HTML_FILE="$HOME/Documents/Software/mac_utls/antigravity.html"

# Try Chrome first, then Safari
if [ -d "/Applications/Google Chrome.app" ]; then
    open -a "Google Chrome" --new --args --app="file://$HTML_FILE" --window-size=1200,800
elif [ -d "/Applications/Safari.app" ]; then
    open -a Safari "file://$HTML_FILE"
else
    open "file://$HTML_FILE"
fi
LAUNCHER

chmod +x "$APP_PATH/Contents/MacOS/launch"

# Create a simple icon (text-based, you can replace with a proper .icns file later)
# For now, we'll use the default app icon
echo "App bundle created at: $APP_PATH"
echo ""
echo "To add to your Dock:"
echo "1. Open Finder and navigate to: $APP_DIR"
echo "2. Drag '$APP_NAME.app' to your Dock"
echo ""
echo "Or run: open '$APP_DIR'"
echo ""
echo "Installation complete! 🚀"

# Open the Applications folder
open "$APP_DIR"
