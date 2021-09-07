#!/bin/sh

# Reset the background
feh --no-fehbg --randomize --bg-fill $(xdg-user-dir PICTURES)/Ozadja/* &

# Refresh the polybar
$HOME/.config/polybar/polybar_launch.sh

# List of programs to start
# Add multiple instances of the same program next to eachother
# and put "heavy" programs at the end
$HOME/.config/autorandr/programs_autorestart.sh \
"nm-applet" \
"conky" \
"blueman-applet" \
"flameshot" \
"slack -u"
