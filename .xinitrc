# Detect the current monitor setup and change to that profile
autorandr --change --default homepc

# Merge .Xresources
[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

# Set keyboard layout for xserver
setxkbmap si

# Source xmodmap table
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

# Set a smaller keyrate
xset r rate 300 50 &

# Enable touchpad tap-click and natural scrolling
xinput set-prop 13 345 1
xinput set-prop 13 353 1

# Composite manager
picom -b

# Source the .xprofile
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# Start the window manager
exec bspwm
