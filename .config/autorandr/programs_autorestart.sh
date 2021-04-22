#!/bin/sh

# List of programs to start
# Add multiple instances of the same program next to eachother
#set --      "nm-applet"
#set -- "$@" "blueman-applet"
#set -- "$@" "flameshot"
#set -- "$@" "slack -u"

# Colors for prettier output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

for program in "$@"; do
    #Take the first string from the list and it's previous value
    prev_program=$only_program
    only_program=$(echo $program | awk '{print $1}')

    if [ "$only_program" = "$prev_program" ]; then
        printf "Skipping killing of $only_program because of multiple instances\n"
    else
        # Stop all processes
        killall -q $only_program >/dev/null 2>/dev/null

        # Wait until the process is killed
        printf "${RED}Stopping${NC} $only_program..."
        while pgrep -x $only_program >/dev/null 2>/dev/null; do sleep 1; printf "."; done
        printf "${RED}Stopped${NC} $only_program\n"
    fi

    # Start the processes again (full command)
    $program >/dev/null 2>/dev/null &
    printf "${GREEN}Restarted${NC} $only_program\n"
done
