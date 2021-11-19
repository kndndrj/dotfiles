# Detect the current monitor setup and change to that profile
autorandr --change --default homepc

# Set keyboard layout for xserver
setxkbmap si

# Set a smaller keyrate
xset r rate 300 50 &

# Enable touchpad tap-click and natural scrolling
xinput set-prop 13 322 1
xinput set-prop 13 330 1

# Composite manager
picom -b

# Source the .xprofile
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# Misc
wmname compiz
export _JAVA_AWT_WM_NONREPARENTING=1
envsubst < ~/.config/dunst/dunstrc_template > ~/.config/dunst/dunstrc

# Start the window manager
exec bspwm

# vim: ft=sh
