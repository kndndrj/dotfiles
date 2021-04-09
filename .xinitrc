# Set keyboard layout for xserver
setxkbmap si

# Merge .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Source xmodmap table
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Source the .xprofile
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# Start the window manager
exec bspwm
