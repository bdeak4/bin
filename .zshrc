autoload -Uz promptinit && promptinit
prompt adam2 && setopt promptsp

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

bindkey -e

setopt sharehistory
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line

ctrl_z() { BUFFER="fg"; zle accept-line }
zle -N ctrl_z
bindkey "^Z" ctrl_z

export EDITOR=vim
alias g=git
