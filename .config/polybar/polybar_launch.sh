#!/bin/sh

# restart window titles daemon
while pgrep -f "bspwm_window_titles.sh" >/dev/null; do pkill -f bspwm_window_titles.sh; done
$HOME/.config/polybar/scripts/bspwm_window_titles.sh &

CPID=$(pgrep -x polybar)

if [ -n "${CPID}" ] ; then
  kill -TERM ${CPID}
fi

# add window titles
# using bspc query here to get monitors in the same order bspwm sees them
for m in $( bspc query -M --names ); do
  index=$((index + 1))

  if [ $index -eq 1 ]; then
    MONITOR=$m polybar --reload floating_right &
    MONITOR=$m polybar --reload floating_left &
    MONITOR=$m polybar --reload floating_center &
  else
    MONITOR=$m polybar --reload floating_external &
  fi
done
