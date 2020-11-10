#!/bin/sh

TEMP=$(sensors | awk '/temp1/ {gsub("\+",""); print $2}')
echo "$TEMP" | awk '{ printf(" 🎞️ %s \n"), $1}'
