#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set NeoVim as default editor
export VISUAL=nvim;
export EDITOR=nvim;

# Add transparency to bash window
# [ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

alias ls='ls --color=auto'
PS1="\[\e[1;32m\]\u\[\e[1;37m\]@\\h: \[\e[1;34m\]\\W\\[\e[1;37m\]$ \[\e[0;37m\]"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

