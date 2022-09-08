#
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
command -v exa &> /dev/null && alias tree='exa -Ta' || alias tree='tree -Ca'
command -v colordiff &> /dev/null && alias diff='colordiff'
command -v bat &> /dev/null && alias cat='bat --theme=OneHalfDark --paging=never --style=plain'
command -v bat &> /dev/null && export MANPAGER="sh -c 'col -bx | bat --theme=OneHalfDark -l man -p'"
command -v fd &> /dev/null || alias fd='find -iname'
alias mv='mv -i'
alias grep='grep --color=auto'
alias vim='nvim'
alias vi='nvim'


#
# Plugins
#
# Install zplug if not present
export ZPLUG_HOME="$HOME/.local/share/zsh/zplug"
if [ ! -d "$ZPLUG_HOME" ]; then
    printf "First time setup. Install zplug? [y/N]: "
    if read -q; then
        echo
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
        sleep 1
    else
      echo
      echo "Proceeding with minimal config."
      return
    fi
fi

source "$ZPLUG_HOME"/init.zsh

# Plugin list
zplug "woefe/git-prompt.zsh", use:"{git-prompt.zsh,examples/compact.zsh}"
zplug "jeffreytse/zsh-vi-mode"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zdharma-continuum/fast-syntax-highlighting", defer:3
zplug "joshskidmore/zsh-fzf-history-search"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load all plugins
zplug load


#
# Extra keybindings
#
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
# Prompt color for vi mode
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL) vimodecol='green'; vimode='NORMAL';;
    $ZVM_MODE_INSERT) vimodecol='blue'; vimode='INSERT';;
    $ZVM_MODE_VISUAL) vimodecol='magenta'; vimode='VISUAL';;
    $ZVM_MODE_VISUAL_LINE) vimodecol='magenta'; vimode='V-LINE';;
    $ZVM_MODE_REPLACE) vimodecol='red'; vimode='REPLACE';;
  esac
}

PROMPT='%B%F{yellow}%n%f@%M: %F{blue}%c%f%b $(gitprompt)
%B%F{${vimodecol}}${vimode}%f%(?..%F{red})❯❯%f%b '
