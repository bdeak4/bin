autoload -Uz promptinit && promptinit
PROMPT="%F{cyan}[%n@%m %~]%f%(#.#.$) "

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

bindkey -e

export EDITOR=vim

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

eval "$(thefuck --alias)"
