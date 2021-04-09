#!/bin/sh

# If you need to run a command with 2 levels of nesting, escape the double quotes e.g. \"
zsh -is eval   "alias vi='nvim -u $HOME/.config/nvim/alternative.vim';
                alias cat='bat --theme Solarized\ \(light\)';
                export MANPAGER=\"sh -c 'col -bx | bat --theme Solarized\ \(light\) -l man -p'\";
                export VISUAL='nvim -u $HOME/.config/nvim/alternative.vim';
                export EDITOR='nvim -u $HOME/.config/nvim/alternative.vim';"

