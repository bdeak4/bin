# environment
export EDITOR="vim"
export PAGER="less"
export BROWSER="links"

# source bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# path
PATH=~/.local/bin:$PATH
PATH=~/.cargo/bin:$PATH

# mac gnu coreutils 
if [ `uname` == "Darwin" ]; then
    PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
    PATH=/usr/local/opt/findutils/libexec/gnubin:$PATH
    PATH=/usr/local/opt/gnu-tar/libexec/gnubin:$PATH
    PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH
    PATH=/usr/local/opt/gnu-indent/libexec/gnubin:$PATH
    PATH=/usr/local/opt/grep/libexec/gnubin:$PATH
    MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
    MANPATH=/usr/local/opt/findutils/libexec/gnuman:$MANPATH
    MANPATH=/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH
    MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH
    MANPATH=/usr/local/opt/gnu-indent/libexec/gnuman:$MANPATH
    MANPATH=/usr/local/opt/grep/libexec/gnuman:$MANPATH
fi
