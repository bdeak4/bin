set -x PATH ~/.local/bin $PATH
set -x EDITOR kak

abbr -a g git
abbr -a gs git status
abbr -a ga git add
abbr -a gc git commit
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gl git log --graph --oneline --decorate --all
abbr -a gp git push
abbr -a gpom git push origin master
abbr -a gpl git pull

# colored man pages
set -x LESS_TERMCAP_md \e'[01;36m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_so \e'[01;32m'
set -x LESS_TERMCAP_se \e'[0m'

# ripgrep
set -x RIPGREP_CONFIG_PATH ~/.ripgreprc

# go
set -x PATH /usr/local/go/bin $PATH
set -x GOPATH ~/.go
set -x PATH ~/.go/bin $PATH

# rust
set -x PATH ~/.cargo/bin $PATH

# yarn
set -x PATH ~/.yarn/bin $PATH
