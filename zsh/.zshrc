### zsh options

# enable colors
autoload -U colors && colors

# prompt
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$ZDOTDIR/history"
setopt append_history

# autocomplete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)


### vi mode

bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# cursor shape
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}

# edit line in vim
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


### load

# aliases
[ -f "$ZDOTDIR/aliases" ] && source "$ZDOTDIR/aliases"

# completions
[ -f "$ZDOTDIR/completions" ] && source "$ZDOTDIR/completions"

# configurations
[ -f "$ZDOTDIR/configurations" ] && source "$ZDOTDIR/configurations"


### plugins

# zsh-autosuggestions
[ -f "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting
[ -f "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
