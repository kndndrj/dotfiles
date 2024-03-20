#!/bin/sh
# Sway start script

# Environment variables

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/bin/scripts"

# Specific program configs or cache locations
export HISTFILE="$XDG_DATA_HOME/bash/history"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PATH="$PATH:$CARGO_HOME/bin"
export GOPATH="$XDG_DATA_HOME/go"
export PATH="$PATH:$GOPATH/bin"
export GO111MODULE=on
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Go
export PATH="$PATH:$GOPATH/bin"
# Java AWT apps
export _JAVA_AWT_WM_NONREPARENTING=1
# EFL apps
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl

# Waybar tray misc
export XDG_CURRENT_DESKTOP=sway


# Set dependencies to run with proprietary drivers
unsupported_gpu=""
if grep -qE "nvidia|fglrx" /proc/modules; then
   export WLR_NO_HARDWARE_CURSORS=1
   unsupported_gpu="--unsupported-gpu"
fi

# Start sway
exec sway $unsupported_gpu > /var/log/sway.log 2>&1
