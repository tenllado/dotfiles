#!/bin/bash

# sway-common.sh
# Common helper for sway window management scripts.

list_sway_windows() {
  swaymsg -t get_tree | jq -r '
    def pad(n):
      tostring as $s
      | if ($s | length) >= n then $s
        else $s + (" " * (n - ($s | length)))
        end;

    ..
    | objects
    | select(.type == "workspace")
    | (if .name == "__i3_scratch" then "scratch" else .name end) as $ws
    | ..
    | objects
    | select(has("app_id") or has("window_properties"))
    | (if .focused then "*" else " " end) as $asterisk
    | (if .shell == "xwayland"
        then (.window_properties.class // .app_id)
        else .app_id end) as $app
    | "[\($ws)]" as $ws_label
    | "\(.id | pad(2))\t\($ws_label | pad(11))\t\($asterisk | pad(1))\($app | pad(25))\t\(.name // "untitled")\u0000icon\u001f\($app)"
  ' | sed 's/&/&amp;/g'
}
