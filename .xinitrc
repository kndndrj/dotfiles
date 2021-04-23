# Detect the current monitor setup and change to that profile
autorandr --change

# Set keyboard layout for xserver
setxkbmap si -option caps:escape

# Merge .Xresources
[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

# Source xmodmap table
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

# Set a smaller keyrate
xset r rate 300 &

# Composite manager
picom &

# Source the .xprofile
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# Start the window manager
exec bspwm
