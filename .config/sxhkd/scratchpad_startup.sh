#!/bin/sh

# If you need to run a command with 2 levels of nesting, escape the double quotes e.g. \"
zsh -is eval   "alias vi='nvim -u $HOME/.config/nvim/init_alt.lua';
                alias vim='nvim -u $HOME/.config/nvim/init_alt.lua';
                alias cat='bat --theme OneHalfLight';
                export MANPAGER=\"sh -c 'col -bx | bat --theme OneHalfLight -l man -p'\";
                export VISUAL='nvim -u $HOME/.config/nvim/init_alt.lua';
                export EDITOR='nvim -u $HOME/.config/nvim/init_alt.lua';"

