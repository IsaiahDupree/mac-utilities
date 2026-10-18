# Google Antigravity for Mac 🚀

A fun physics-based recreation of the classic Google Antigravity easter egg, packaged as a Mac application.

## Features

- Click the Google logo to activate antigravity mode
- Interactive physics simulation with Matter.js
- Drag and throw objects around with your mouse
- Beautiful Google-style interface

## Quick Start

### Option 1: Install to Dock (Recommended)

Run the installation script to create a Mac app that appears in your Dock:

```bash
chmod +x install_to_dock.sh
./install_to_dock.sh
```

This will:
1. Create a `Google Antigravity.app` in your `~/Applications` folder
2. Open the Applications folder so you can drag it to your Dock

### Option 2: Open Directly in Browser

Simply open the HTML file:

```bash
open antigravity.html
```

### Option 3: Launch Script

Use the launch script to open in Chrome app mode:

```bash
chmod +x launch.sh
./launch.sh
```

## How to Use

1. Launch the app from your Dock or browser
2. Click the colorful "Google" logo in the center
3. Watch as everything floats away with antigravity!
4. Use your mouse to drag and throw objects around
5. Have fun! 🎉

## Requirements

- macOS 10.10 or later
- Google Chrome or Safari (Chrome recommended for best experience)
- Internet connection (for Matter.js physics library)

## Customization

The app uses Matter.js for physics simulation. You can edit `antigravity.html` to:
- Change gravity strength
- Add more objects
- Modify colors
- Adjust physics properties

## Uninstall

To remove from Dock:
1. Right-click the app icon in the Dock
2. Select "Options" → "Remove from Dock"

To completely uninstall:
```bash
rm -rf ~/Applications/Google\ Antigravity.app
```

---

Enjoy your antigravity experience! 🌌
