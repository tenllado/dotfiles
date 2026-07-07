#!/usr/bin/env bash

apt_updates=$(apt-get -q -y --ignore-hold --allow-change-held-packages --allow-unauthenticated -s dist-upgrade | grep ^Inst | wc -l)

if [ "$apt_updates" -gt 0 ]; then
    # Shows package count + package icon ()
    echo "$apt_updates "
else
    # Muted or hidden when empty (using a checkmark icon)
    echo ""
fi
