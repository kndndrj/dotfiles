#!/bin/sh

TEMP1=$(sensors | awk '/Core 0/ {gsub("\+",""); print $3}')
TEMP2=$(sensors | awk '/Core 1/ {gsub("\+",""); print $3}')
CPU_USAGE=$(mpstat 1 1 | awk '/Average:/ {printf("%s\n", $(NF-9))}')
echo -e "\uf2db $CPU_USAGE \uf2c8 $TEMP1 $TEMP2" | awk '{ printf("%s %s% : %s %s|%s\n"), $1, $2, $3, $4, $5 }'
