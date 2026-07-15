#!/usr/bin/env bash

fw_updates=0
if command -v fwupdmgr >/dev/null 2>&1; then
    # Count the devices that have firmware updates available
    fw_updates=$(fwupdmgr get-updates --non-interactive 2>/dev/null | grep -c '^[•▪]')
fi

if [ "$fw_updates" -gt 0 ]; then
    # Output the JSON format Waybar expects
    # 'text' is what displays on the bar, 'alt' triggers styling rules, 'tooltip' is the hover text
    echo "{\"text\": \"$fw_updates\", \"alt\": \"has-updates\", \"tooltip\": \"$fw_updates firmware update(s) available\"}"
else
    # Output empty JSON so the module stays completely hidden when there are no updates
    echo "{\"text\": \"\", \"alt\": \"updated\", \"tooltip\": \"Firmware is up to date\"}"
fi
