#!/bin/bash


if ! nm-online ; then
	exit 0
fi

notmuch new
