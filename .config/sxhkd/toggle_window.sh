#!/bin/sh

# Help message
HELP="$0 -w <window class> -c <command to run> [-p left/right/center]"

# Parse arguments
while getopts ":w:c:p:" option; do
    case "${option}" in
        w) 
            WINDOW_CLASS=${OPTARG};;
        c) 
            COMMAND=${OPTARG};;
        p) 
            POSITION=${OPTARG};;
        :)
            printf "Error: -${OPTARG} requires an argument.\nUsage:\n${HELP}\n"
            exit;;
        *)  printf "Error: invalid argument: \"-${OPTARG}\".\nUsage:\n${HELP}\n"
            exit;;
    esac
done

if [ -z "$WINDOW_CLASS" ] || [ -z "$COMMAND" ]; then
    printf "Not enough arguments provided!\n"
    printf "Usage:\n${HELP}\n"
    exit 1
fi

# Search for a window
WINDOW_ID=$(xdotool search --classname $WINDOW_CLASS)
if [ -z $WINDOW_ID ]; then
    $COMMAND &
    while true; do
        WINDOW_ID=$(xdotool search --classname $WINDOW_CLASS)
        [ -z $WINDOW_ID ] || break
    done

    sleep .1
    i3-msg "[id=$WINDOW_ID]" floating enable
    i3-msg "[id=$WINDOW_ID]" move scratchpad
    i3-msg "[id=$WINDOW_ID]" scratchpad show
    i3-msg "[id=$WINDOW_ID]" border pixel 2

    # Apply position if specified
    if [ ! -z $POSITION ]; then
        # POS command output: window geometry $13 x $14, display size: $15 x $16:
        case "$POSITION" in
            left)
                POS=$(xdotool getwindowgeometry $WINDOW_ID getdisplaygeometry \
                    | awk -F "[ ,x\n]" 'BEGIN {RS=""} END {print ($15/2)-$13-3, ($16-$14)/2}');;
            center)
                POS=$(xdotool getwindowgeometry $WINDOW_ID getdisplaygeometry \
                    | awk -F "[ ,x\n]" 'BEGIN {RS=""} END {print ($15-$13)/2, ($16-$14)/2}');;
            right)
                POS=$(xdotool getwindowgeometry $WINDOW_ID getdisplaygeometry \
                    | awk -F "[ ,x\n]" 'BEGIN {RS=""} END {print ($15/2)+3, ($16-$14)/2}');;
        esac
        # Move the window to the location
        xdotool windowmove $WINDOW_ID $POS
    fi

else
    # Toggle visibility, put to the focused monitor and focus the scrathcpad
    i3-msg "[id=$WINDOW_ID]" scratchpad show
fi
