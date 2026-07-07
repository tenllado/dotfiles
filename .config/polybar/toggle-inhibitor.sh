#!/usr/bin/env bash

# Define the state tracking file
LOCK_FILE="$HOME/.cache/polybar-lock-inhibited"

if [ -f "$LOCK_FILE" ]; then
    # If the file exists, remove it and re-enable DPMS/Screensaver (Turn ON sleep)
    rm "$LOCK_FILE"
    xset s on +dpms
else
    # If it doesn't exist, create it and disable DPMS/Screensaver (Turn OFF sleep)
    touch "$LOCK_FILE"
    xset s off -dpms
fi

# Force Polybar to instantly re-run the script for the idle-inhibitor module
polybar-msg cmd action "#idle-inhibitor.exec"
