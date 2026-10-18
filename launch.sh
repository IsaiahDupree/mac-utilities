#!/bin/bash
# Launch Google Antigravity in a new browser window
open -a "Google Chrome" --new --args --app="file://$(dirname "$0")/antigravity.html" --window-size=1200,800
