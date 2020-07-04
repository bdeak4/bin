PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
HISTSIZE=1000000
HISTFILESIZE=$HISTSIZE
EDITOR=vi
PATH=~/dotfiles/scripts:$PATH

shopt -s globstar

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -lAF'
alias la='ls -AF'

[ -f /etc/bash_completion ] && . /etc/bash_completion

# go
GOPATH=~/.go
PATH=~/.go/bin:$PATH
