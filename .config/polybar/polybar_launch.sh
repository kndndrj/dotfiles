#!/bin/sh

# Terminate already running bar instances
killall -q polybar
killall -q titles-bspwm.sh

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
while pgrep -u $UID -f "titles-bspwm.sh" >/dev/null; do sleep 1; done

# Start window titles daemon
$HOME/.config/polybar/scripts/titles-bspwm.sh >/dev/null &

# Start polybar on all monitors
for m in $(bspc query -M --names); do
  index=$((index + 1))

  if [ $index -eq 1 ]; then
    MONITOR=$m polybar fixed &
  else
    MONITOR=$m polybar fixed_external &
  fi
done
