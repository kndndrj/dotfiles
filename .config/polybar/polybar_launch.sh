#!/bin/sh

# Terminate already running bar instances
killall -q polybar
killall -q bspwm_window_titles.sh

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
while pgrep -u $UID -f "bspwm_window_titles.sh" >/dev/null; do sleep 1; done

# Start window titles daemon
$HOME/.config/polybar/scripts/bspwm_window_titles.sh &

# Start polybar on all monitors
for m in $(bspc query -M --names); do
  index=$((index + 1))

  if [ $index -eq 1 ]; then
    MONITOR=$m polybar --reload floating_right &
    MONITOR=$m polybar --reload floating_left &
    MONITOR=$m polybar --reload floating_center &
  else
    MONITOR=$m polybar --reload floating_external &
  fi
done
