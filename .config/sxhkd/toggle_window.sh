#!/bin/sh

while getopts w:c:p: option; do
    case "${option}" in
        w) WINDOW_CLASS=${OPTARG};;
        c) COMMAND=${OPTARG};;
        p) POSITION=${OPTARG};;
    esac
done

HELP="Usage: \n $0 -w <window class> -c <command to run> [-p left/right/center]"
if [ -z "$WINDOW_CLASS" ] || [ -z "$COMMAND" ]; then
    echo -e $HELP
    exit 1
fi

WINDOW_ID=$(xdotool search --classname $WINDOW_CLASS)
if [ -z $WINDOW_ID ]; then
    $COMMAND &
    while true; do
        if [ -z $(xdotool search --classname $WINDOW_CLASS) ]; then
            : 
        else
            break
        fi
    done

    WINDOW_ID=$(xdotool search --classname $WINDOW_CLASS)

    if [ -z $POSITION ]; then
        echo "If you also wanted to position the window, add a [-p] argument:"
        echo -e $HELP
    else
        # command output: window geometry $13 x $14, display size: $15 x $16:
        LEFT=$(xdotool getwindowgeometry $WINDOW_ID getdisplaygeometry | awk -F "[ ,x\n]" 'BEGIN {RS=""} END {print ($15/2)-$13-3, ($16-$14)/2}')
        RIGHT=$(xdotool getwindowgeometry $WINDOW_ID getdisplaygeometry | awk -F "[ ,x\n]" 'BEGIN {RS=""} END {print ($15/2)+3, ($16-$14)/2}')
        CENTER=$(xdotool getwindowgeometry $WINDOW_ID getdisplaygeometry | awk -F "[ ,x\n]" 'BEGIN {RS=""} END {print ($15-$13)/2, ($16-$14)/2}')

        case "$POSITION" in
            left) xdotool windowmove $WINDOW_ID $LEFT;;
            center) xdotool windowmove $WINDOW_ID $CENTER;;
            right) xdotool windowmove $WINDOW_ID $RIGHT;;
        esac
    fi

else
    bspc node $WINDOW_ID --flag hidden -f
fi


