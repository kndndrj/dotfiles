#!/bin/sh

# List of programs to start
# Add multiple instances of the same program next to eachother
# and put "heavy" programs at the end
$HOME/.config/autorandr/programs_autorestart.sh \
"nm-applet" \
"blueman-applet" \
"flameshot" \
"slack -u"
