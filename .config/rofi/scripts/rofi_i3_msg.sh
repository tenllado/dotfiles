#!/bin/bash

# Use rofi to send commands to i3, using i3-msg underneath. It manages a history
# file offered to the user in the rofi list window.
#
# Author: Christian Tenllado
# e-mail: ctenllado@gmail.com

HISTORY_FILE=~/.local/share/rofi/rofi_i3_history
MAX_HISTORY_SIZE=20

history_trunc() {
	history_len=$(cat ${HISTORY_FILE} | wc -l)
	while [ $history_len -gt ${MAX_HISTORY_SIZE} ]; do
		sed -i 1d "${HISTORY_FILE}"
		history_len=$(cat ${HISTORY_FILE} | wc -l)
	done
}

history_add() {
	command=$(echo "$@" | sed -e 's/\(\[\|\]\)/\\&/g')
	sed -i "/$command/d" "${HISTORY_FILE}"
	echo "$@" >> "${HISTORY_FILE}"
}

if [ ! -d $(dirname "${HISTORY_FILE}") ]; then
	mkdir -p "$(dirname "${HISTORY_FILE}")"
fi

if [ $# -eq 0 ]; then
	# Output to rofi, history of commands
	tac "${HISTORY_FILE}"
else
	history_add $@
	history_trunc
    i3-msg "$@" > /dev/null
fi
