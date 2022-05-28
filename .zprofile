# Start X-server when I log in
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec $HOME/.config/sway/swaystart
fi
