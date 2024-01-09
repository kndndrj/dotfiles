#!/bin/zsh
# Basics
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set NeoVim as default editor
export VISUAL=nvim;
export EDITOR=nvim;

# Set ssh-agent to the terminal
eval $(ssh-agent) > /dev/null

# Enable colors
autoload -U colors && colors

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
[ ! -f "$HISTFILE" ] && mkdir -p "$(dirname "$HISTFILE")" && touch "$HISTFILE"


#
# Completion
#
# Enable completion
autoload -Uz compinit
compinit
# ...case insensitive
zstyle ':completion:*' matcher-list ''m:{a-z}={A-Z}''
# ...with hidden files
zstyle ':completion:*' menu select
_comp_options+=(globdots)
zmodload zsh/complist
# ...complete aliases
setopt COMPLETE_ALIASES


#
# Alisases
#
alias ls='ls --color=auto'
command -v exa &> /dev/null && alias l='exa' || alias l='ls --color=auto'
command -v exa &> /dev/null && alias ll='exa -al --git' || alias ll='ls --color=auto -alh'
command -v exa &> /dev/null && alias tree='exa -T' || alias tree='tree -C'
command -v colordiff &> /dev/null && alias diff='colordiff'
command -v bat &> /dev/null && alias cat='bat --theme=ansi --paging=never --style=plain'
command -v bat &> /dev/null && export MANPAGER="sh -c 'col -bx | bat --theme=OneHalfDark -l man -p'"
command -v fd &> /dev/null || alias fd='find -iname'
alias mv='mv -i'
alias grep='grep --color=auto'
alias vim='nvim'
alias vi='nvim'
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"


#
# Plugins
#
# zcomet home directory
export ZCOMET_HOME="$HOME/.local/share/zsh/zcomet"
zstyle ':zcomet:*' home-dir "$ZCOMET_HOME"
# Install zcomet if not present
if [ ! -d "$ZCOMET_HOME"/bin ]; then
    printf "First time setup. Install zcomet? [y/N]: "
    if read -q; then
        echo; echo "Installing zcomet..."
        git clone https://github.com/agkozak/zcomet.git "$ZCOMET_HOME"/bin || return 1
        echo "Successfully installed zcomet!"
    else
        echo
        echo "Proceeding with minimal config."
        return
    fi
fi

source "$ZCOMET_HOME"/bin/zcomet.zsh

# Plugin list
zcomet load "woefe/git-prompt.zsh" git-prompt.zsh examples/compact.zsh
zcomet load "jeffreytse/zsh-vi-mode"
zcomet load "zsh-users/zsh-autosuggestions"
zcomet load "ohmyzsh" plugins/command-not-found
zcomet load "joshskidmore/zsh-fzf-history-search"
zcomet load "zdharma-continuum/fast-syntax-highlighting"

# Load all plugins (install missing ones)
zcomet compinit


#
# Extra keybindings
#

# Vim plugin config
function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

# Vim plugin after init
function zvm_after_init() {
    bindkey -M main '^N' expand-or-complete
    bindkey -M main '^P' reverse-menu-complete
}

# Vim plugin after lazy loading keybindings
function zvm_after_lazy_keybindings() {
    command -v fzf &> /dev/null && bindkey -M vicmd '/' fzf_history_search
}


#
# Prompt
#
PROMPT='%B%F{yellow}%n%f@%M: %F{blue}%c%f%b
%B%(?..%F{red})❯❯%f%b '
RPROMPT='$(gitprompt)'


#
# Tmux
#
# Try attaching to tmux session or create a new one
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [ "$TERM" != "screen" ] && [ "$TERM" != "tmux" ] && [ -z "$TMUX" ]; then
    open_tmux() {
        tmux attach 2> /dev/null || tmux
    }
    exec open_tmux
fi
