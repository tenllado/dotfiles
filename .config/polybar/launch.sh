#!/usr/bin/env bash

# 1. Terminate already running bar instances
pkill polybar

# 2. Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 3. Launch your bar
exec polybar i3bar &
