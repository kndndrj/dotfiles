#!/bin/sh

app_id="$1$2"
position="$2"
term_cmd="$3"

[ -z "$3" ] && exit 1

if ! swaymsg [app_id="$app_id"] scratchpad show; then
	$term_cmd --class "$app_id" &
	sleep 0.2
fi

# Get monitor specs
screen_rect="$(swaymsg -t get_outputs --raw | jq ".[] | select( .focused == true).rect")"

screen_x="$(echo "$screen_rect" | jq ".x")"
screen_y="$(echo "$screen_rect" | jq ".y")"

screen_width="$(echo "$screen_rect" | jq ".width")"
screen_height="$(echo "$screen_rect" | jq ".height")"

# Set window sizes based on screen size
width="$(echo "scale=0;($screen_width*0.4)/1" | bc)"
height="$(echo "scale=0;($screen_height*0.45)/1" | bc)"

# Set positions based on left/right
y="$(echo "scale=0;($screen_y+($screen_height*0.35))/1" | bc)"
if [ "$position" = "left" ]; then
	x="$(echo "scale=0;($screen_x+($screen_width*0.1))/1" | bc)"
elif [ "$position" = "right" ]; then
	x="$(echo "scale=0;($screen_x+($screen_width*0.5))/1" | bc)"
else
	echo "invalid position"
	exit 1
fi

swaymsg [app_id="$app_id"] resize set "$width" "$height"
swaymsg [app_id="$app_id"] move absolute position "$x" "$y"
