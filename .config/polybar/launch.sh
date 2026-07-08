#!/usr/bin/env bash

# 1. Terminate already running bar instances
pkill polybar

# 2. Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 3. Detect connected monitors and launch a bar on each one
if command -v xrandr >/dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload i3bar &
  done
else
  polybar --reload i3bar &
fi
