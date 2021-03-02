#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar left_96dpi &
polybar center_96dpi &
polybar right_96dpi &

echo "Polybar launched at 96 dpi"
