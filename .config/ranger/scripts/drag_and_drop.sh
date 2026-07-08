#!/bin/bash

if [ $XDG_SESSION_TYPE == "x11" ]; then
	exec ~/.local/bin/dragon -a -x "$@"
else
	exec ~/.cargo/bin/ripdrag -ax "$@"
fi
