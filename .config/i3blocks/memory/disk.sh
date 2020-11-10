#!/bin/sh

DISKUSAGE=$(df -h /| awk '/\//{ printf("%sB|%sB\n", $3, $2)}') 

echo -e "\uf0a0 $DISKUSAGE"
