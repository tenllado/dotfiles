#!/bin/sh


# ------Get available windows:
       swaymsg -t get_tree |
         jq -r '.nodes[].nodes[] |  if  .nodes  then  [recurse(.nodes[])]
       else [] end + .floating_nodes | .[] | select(.nodes==[]) | ((.id |
       tostring) + " " + .name)' |
         fuzzel -w 50 -d -p "Switch to:" | {
           read -r id name
           swaymsg "[con_id=$id]" focus
       }



## ------Get available windows:
#windows=$(swaymsg -t get_tree | jq -r '
#	recurse(.nodes[]?) |
#		recurse(.floating_nodes[]?) |
#		select(.type=="con"), select(.type=="floating_con") |
#			(.id | tostring) + " " + .app_id + ": " + .name')
#
## ------Limit wofi's height with the number of opened windows:
#height=$(echo "$windows" | wc -l)
#
## ------Select window with wofi:
#selected=$(echo "$windows" | wofi -d -i --lines "$height" -p "Switch to:" | awk '{print $1}')
#
## ------Tell sway to focus said window:
#swaymsg [con_id="$selected"] focus
