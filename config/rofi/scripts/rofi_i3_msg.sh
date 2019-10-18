#!/bin/bash

# Use rofi to send commands to i3, using i3-msg underneath. It manages a history
# file offered to the user in the rofi list window.
#
# Author: Christian Tenllado
# e-mail: ctenllado@gmail.com

HISTORY_FILE=~/.local/share/rofi/rofi_i3_history
MAX_HISTORY_SIZE=20

if [ ! -d $(dirname "${HISTORY_FILE}") ]; then
	mkdir -p "$(dirname "${HISTORY_FILE}")"
fi

if [ $# -eq 0 ]; then
	# Output to rofi, history of commands
	tac "${HISTORY_FILE}"
else
	# Add command to history and execute it
	command=$(echo "$@" | sed -e 's/\(\[\|\]\)/\\&/g')
	sed -i "/$command/d" "${HISTORY_FILE}"
	echo "$@" >> "${HISTORY_FILE}"
	while [[ $(wc -l "${HISTORY_FILE}") -gt ${MAX_HISTORY_SIZE} ]]; do
		sed -i 1d "${HISTORY_FILE}"
	done
    i3-msg $@ > /dev/null
fi
