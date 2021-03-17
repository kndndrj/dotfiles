# Set keyboard layout for xserver, remap caps_lock to escape
setxkbmap si

# Merge .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Source the .xprofile
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# Start the window manager
bspwm
