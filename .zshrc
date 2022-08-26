#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set NeoVim as default editor
export VISUAL=nvim;
export EDITOR=nvim;

# Set ssh-agent to the terminal
eval $(ssh-agent) > /dev/null

# Enable colors and change prompt - add git prompt to the right:
autoload -U colors && colors
source $HOME/.config/zsh/git-prompt.zsh

# Random prompt color
case $(shuf -e 1 2 3 4 5 6 | head -n 1) in
  1) usercol='yellow';;
  2) usercol='green';;
  3) usercol='blue';;
  4) usercol='red';;
  5) usercol='magenta';;
  6) usercol='cyan';;
esac

# Simple prompt
#PROMPT='%B%F{${usercol}}%n%f@%M: %F{blue}%25<..<%c%f%(?..%F{red})$%f%b '
#RPROMPT='$(gitprompt)'
# Two row prompt
PROMPT='%B%F{${usercol}}%n%f@%M: %F{blue}%c%f%b $(gitprompt)%B
%(?..%F{red})╰─>%f%b '
# Funny prompt
#PROMPT='%B%F{${usercol}}%n%f:%F{blue}%c%f%b $(gitprompt)%(?.%F{blue}❯%F{cyan}❯%F{green}❯.%F{red}❯❯❯)%f '

# Alisases
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

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Enable compinit
autoload -Uz compinit
compinit

# autocomplete - case insensitive
zstyle ':completion:*' matcher-list ''m:{a-z}={A-Z}''

# Enable alias completion
setopt COMPLETE_ALIASES

# Enable completion menu with hidden files
zstyle ':completion:*' menu select
_comp_options+=(globdots)
zmodload zsh/complist

# Enable vi mode
bindkey -v
bindkey -v '^?' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete

# Handler if command not found
function command_not_found_handler {
  local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
  printf 'zsh: command not found: %s\n' "$1"
  local entries=(
    ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
  )
  if (( ${#entries[@]} ))
  then
    printf "${bright}$1${reset} may be found in the following packages:\n"
    local pkg
    for entry in "${entries[@]}"
    do
      # (repo package version file)
      local fields=(
        ${(0)entry}
      )
      if [[ "$pkg" != "${fields[2]}" ]]
      then
        printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
      fi
      printf '    /%s\n' "${fields[4]}"
      pkg="${fields[2]}"
    done
  fi
}

# Source syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 
