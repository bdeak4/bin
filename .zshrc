autoload -Uz compinit && compinit
PROMPT="[%n@%m %~]%(#.#.$) "
export EDITOR=vi
export PATH=~/.local/bin:$PATH
bindkey -e

alias vi="vim"
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gl="git log --graph --oneline --decorate --all"
alias gp="git push"
alias gpom="git push origin master"
alias gpl="git pull"

# TODO
# case insensitive path completion
# source: https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# TODO
# change directory without cd command
# source: http://zsh.sourceforge.net/Intro/intro_16.html
setopt autocd

# TODO
# spelling correction for commands
# source: http://zsh.sourceforge.net/Intro/intro_16.html
# setopt correct

# TODO
# share history across sessions
# source: https://news.ycombinator.com/item?id=5692075
setopt sharehistory

# TODO
# don't save commands starting with space in history
# source: https://news.ycombinator.com/item?id=5692075
setopt histignorespace

export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history

# TODO
# move to next match in history search
# source: https://www.gnu.org/software/emacs/manual/html_node/emacs/Repeat-Isearch.html
# ^R

# TODO
# history search for last search string
# source: https://www.gnu.org/software/emacs/manual/html_node/emacs/Repeat-Isearch.html
# ^R^R

# TODO
# filter history backward/forward with substring
# source: https://unix.stackexchange.com/a/461262
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# TODO
# search history shortcuts
# source: https://stackoverflow.com/a/14469720/11197595
# $ !vi<tab>
# $ vi ~/.zshrc
# $ !?zshrc
# $ vi ~/.zshrc

# open current line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line

# TODO
# switch back to suspended program
ctrl_z() {
  BUFFER="fg"
  zle accept-line
}
zle -N ctrl_z
bindkey "^Z" ctrl_z

# colored man pages
export LESS_TERMCAP_md=$'\e[01;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;32m'
export LESS_TERMCAP_se=$'\e[0m'

# go
export PATH=/usr/local/go/bin:$PATH
export GOPATH=~/.go
export PATH=~/.go/bin:$PATH

# rust
export PATH=~/.cargo/bin:$PATH
