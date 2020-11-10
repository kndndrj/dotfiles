#!/bin/sh

RAMUSAGE=$(free -h | awk '/Mem:/ {gsub("\i",""); printf("%sB|%sB\n", $3, $2)}') 

echo -e "\uf538 $RAMUSAGE"
