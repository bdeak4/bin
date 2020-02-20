# prompt
PS1="\033[0;31m[\033[0;33m\u\033[0;32m@\033[0;34m\h \033[0;35m\w\033[0;31m]\033[0m\$ "

# history
HISTSIZE=10000
HISTFILESIZE=10000

# aliases
alias v="vim"
alias m="mutt"
alias g="git"
alias n="nnn"
alias t="tmux"
alias y="yarn"

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# cd
shopt -s autocd
shopt -s cdspell

# fzf
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden -g '!.git'"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS=\
"--color=bg+:#282828,bg:#181818,spinner:#86c1b9,hl:#7cafc2
--color=fg:#b8b8b8,header:#7cafc2,info:#f7ca88,pointer:#86c1b9
--color=marker:#86c1b9,fg+:#e8e8e8,prompt:#f7ca88,hl+:#7cafc2
--bind 'ctrl-a:select-all'"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# nnn
export NNN_CONTEXT_COLORS="4231"
export NNN_BMS="d:~/dev/;D:~/downloads/;c:~/config/;s:~/config/scripts"
export NNN_TRASH=1
export NNN_USE_EDITOR=1

# colored man pages
export LESS_TERMCAP_md=$'\e[01;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_se=$'\e[0m'
