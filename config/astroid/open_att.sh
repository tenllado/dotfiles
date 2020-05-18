#! /usr/bin/bash

# apparently file is closed twice, first time something like file --mime-type
# opens and closes the file. After that xdg runs the selected program which
# opens the file and closes it

# uncoment this is for debug purposes
#exec >~/.config/astroid/external_open.log
#exec 2>&1
#echo "opening $1"

type=$(file --mime-type $1 | awk '{print $2}')

if [[ "$type" == "text/calendar" ]]; then
	desc="$(~/.config/astroid/mutt_icalparser $1)"
	# use this with the zenity option --radiolist (and add another column option) if you prefer radio buttons
	#calchecklist="TRUE $(khal printcalendars | xargs | sed 's/ / FALSE /g')"
	callist="$(khal printcalendars | xargs )"
	cal=$(zenity --height=430 --list --text="import to khal:\n$desc" \
		--column "calendars" $callist)
	if [[ "$?" -eq 0 ]]  ; then
		echo "importing $1 to on calendar $cal"
		khal import -a "$cal" --batch $1
	fi
	# alternative, but does not show calendar description
	#khal printcalendars | dmenu -l 10 -p "khal import:" | \
	#    xargs -r -I personal khal import -a personal --batch $1
else
	inotifywait -e close $1 &
	ip=$!

	xdg-open "$1"

	# wait for first close
	wait $ip

	sleep 5
fi

