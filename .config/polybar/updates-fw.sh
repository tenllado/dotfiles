#!/usr/bin/env bash

fw_updates=0
if command -v fwupdmgr >/dev/null 2>&1; then
    fw_updates=$(fwupdmgr get-updates --non-interactive 2>/dev/null | grep -c '^[•▪]')
fi

if [ "$fw_updates" -gt 0 ]; then
    # Shows firmware count + hardware microchip icon ()
    echo "$fw_updates "
else
    # Keep it completely blank when there are no firmware updates to save bar space
    echo ""
fi
