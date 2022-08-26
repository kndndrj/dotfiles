# Sway start script

# Environment variables

# XDG Base Directories
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin/scripts

# Specific program configs or cache locations
export HISTFILE="$XDG_DATA_HOME"/bash/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export PATH=$PATH:$CARGO_HOME/bin
export GOPATH="$XDG_DATA_HOME"/go
export PATH=$PATH:$GOPATH/bin
export GOPATH=$GOPATH:$HOME/Repos/gocode
export GO111MODULE=on
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# System color settings
export COL_SYSTEM_PRIMARY="#D5AD18"
export COL_SYSTEM_SECONDARY="#DCC080"
export COL_SYSTEM_ALERT="#FF4545"
export COL_SYSTEM_WARN="#FF875A"
export COL_SYSTEM_FOREGROUND="#E9E8E8"
export COL_SYSTEM_BACKGROUND="#444444"
export COL_SYSTEM_FOREGROUND_ALT="#AAAAAA"
export COL_SYSTEM_BACKGROUND_ALT="#1F1E1C"
export COL_SYSTEM_BACKGROUND_TRANSPARENT="#bb${COL_SYSTEM_BACKGROUND#\#}"

# Misc
# Java AWT apps
export _JAVA_AWT_WM_NONREPARENTING=1
# EFL apps
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl
# Replace env variables in configs
envsubst < ~/.config/dunst/dunstrc_template > ~/.config/dunst/dunstrc
envsubst < ~/.config/waybar/style_template.css > ~/.config/waybar/style.css
envsubst '$COL_SYSTEM_PRIMARY $COL_SYSTEM_SECONDARY $COL_SYSTEM_ALERT $COL_SYSTEM_FOREGROUND $COL_SYSTEM_BACKGROUND $COL_SYSTEM_FOREGROUND_ALT $COL_SYSTEM_BACKGROUND_ALT $COL_SYSTEM_BACKGROUND_TRANSPARENT' < ~/.config/sway/config_template > ~/.config/sway/config

# Waybar tray misc
export XDG_CURRENT_DESKTOP=sway

# Start sway
sway --unsupported-gpu > /var/log/sway.log 2>&1

# vim: ft=sh
