PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE
export EDITOR=vi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -lAF'
alias la='ls -AF'

[ -f /etc/bash_completion ] && . /etc/bash_completion

export GOPATH=~/.go
export PATH=~/.go/bin:$PATH
export GEM_HOME=~/.gems
export PATH=~/.gems/bin:$PATH
