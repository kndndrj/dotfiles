#!/bin/sh

zsh -is eval   "alias vim='nvim -u $HOME/.config/nvim/alternative.vim'; 
                export VISUAL='nvim -u $HOME/.config/nvim/alternative.vim';
                export EDITOR='nvim -u $HOME/.config/nvim/alternative.vim';"

