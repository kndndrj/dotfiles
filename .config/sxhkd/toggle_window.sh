#!/usr/bin/bash

if [ -z $1 ]; then
	echo "Usage: $0 <name of hidden window>"
	exit 1
fi

if [ -z $2 ]; then
	echo "Usage: $0 <command to run in case of fail>"
	exit 1
fi

pids=$(xdotool search --classname ${1})
if [ -z $pids ]; then
    $2 &
else
    for pid in $pids; do
    	echo "Toggle $pid"
    	bspc node $pid --flag hidden -f
    done
fi
