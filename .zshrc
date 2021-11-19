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
PROMPT='%B%F{${usercol}}%n%f@%M: %F{blue}%25<..<%c%f%(?..%F{red})$%f%b '
RPROMPT='$(gitprompt)'
# Two row prompt
#PROMPT='%B╭ %(?.%F{green}✓.%F{red}🗴) %F{${usercol}}%n%f@%M: %F{blue}%c%f%b $(gitprompt)%B
#╰─>%f%b '
# Funny prompt
#PROMPT='%B%F{${usercol}}%n%f:%F{blue}%c%f%b $(gitprompt)%(?.%F{blue}❯%F{cyan}❯%F{green}❯.%F{red}❯❯❯)%f '

# Alisases
alias ls='ls --color=auto'
alias ll='ls --color=auto -alh'
alias mv='mv -i'
alias grep='grep --color=auto'
alias vi='nvim'
alias vim='nvim'
alias diff='colordiff'
alias fm='source ranger'
alias get_idf='. $HOME/esp/esp-idf/export.sh'

# For invoking commands on startup (if calling shell with custom parameters
if [[ $1 == eval ]]; then
  "$@"
  set --
fi

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

function zle-keymap-select zle-line-init zle-line-finish {
  case $KEYMAP in
    vicmd)      print -n -- "\E]50;CursorShape=0\C-G";; # block cursor
    viins|main) print -n -- "\E]50;CursorShape=1\C-G";; # line cursor
  esac

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# Handler if command not found
command_not_found_handler() {
  local pkgs cmd="$1" files=()
  printf 'zsh: command not found: %s' "$cmd" # print command not found asap, then search for packages
  files=(${(f)"$(pacman -F --machinereadable -- "/usr/bin/${cmd}")"})
  if (( ${#files[@]} )); then
    printf '\r%s may be found in the following packages:\n' "$cmd"
    local res=() repo package version file
    for file in "$files[@]"; do
      res=("${(0)file}")
      repo="$res[1]"
      package="$res[2]"
      version="$res[3]"
      file="$res[4]"
      printf '  %s/%s %s: /%s\n' "$repo" "$package" "$version" "$file"
    done
  else
    printf '\n'
  fi
  return 127
}

# Display terminal window as: "user@machine..."
autoload -Uz add-zsh-hook
function xterm_title_precmd () {
  print -Pn -- '\e]2;%n@%m %~\a'
  [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}
function xterm_title_preexec () {
  print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
  [[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}
if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
  add-zsh-hook -Uz precmd xterm_title_precmd
  add-zsh-hook -Uz preexec xterm_title_preexec
fi

# Source syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 
