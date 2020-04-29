# completion
autoload -Uz compinit && compinit

# prompt
autoload -Uz promptinit && promptinit
prompt adam2
setopt promptsp # prevent theme from eating output that doesn't end with \n

# env
export EDITOR=vim
export VISUAL=$EDITOR
# export PATH=/usr/local/bin:$PATH
export PATH=~/.local/bin:$PATH
# export PATH=./node_modules/.bin:$PATH

# aliases
# alias vv='vim --noplugin' # without plugins
# alias vvv='vim -N -u NONE' # without vimrc and plugins
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --graph --oneline --decorate --all'
alias gp='git push'
alias gpom='git push origin master'
alias gpl='git pull'

# global aliases
# aliases that can be used everywhere in command
# source: https://www.slideshare.net/brendon_jag/why-zsh-is-cooler-than-your-shell
# alias -g gp='| grep -i'
# $ ps ax gp ruby
# $ ps ax | grep -i ruby

# sufix aliases
# aka open with aliases
# source: https://www.slideshare.net/brendon_jag/why-zsh-is-cooler-than-your-shell
# alias -s rb='vim'
# $ test.rb
# $ vim test.rb

# path expansion
# source: https://www.slideshare.net/brendon_jag/why-zsh-is-cooler-than-your-shell
# $ cd /h/b/d<tab>
# $ cd /home/bartol/dev

# path replacement
# source: https://www.slideshare.net/brendon_jag/why-zsh-is-cooler-than-your-shell
# ~/dev/bartol.dev/app $ cd bartol.dev amadeus2.hr
# ~/dev/amadeus2.hr/app $

# case insensitive path completion
# source: https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# change directory without cd command
# source: http://zsh.sourceforge.net/Intro/intro_16.html
setopt autocd

# spelling correction for commands
# source: http://zsh.sourceforge.net/Intro/intro_16.html
# setopt correct

# programmable file renaming
# source: https://www.slideshare.net/brendon_jag/why-zsh-is-cooler-than-your-shell
# $ zmv '(*).txt' '$1.html'
# renames all txt files in current directory to html
autoload zmv

# run command without alias
# $ \ls

# share history across sessions
# source: https://news.ycombinator.com/item?id=5692075
setopt sharehistory

# don't save commands starting with space in history
# source: https://news.ycombinator.com/item?id=5692075
setopt histignorespace

# larger history size
# source: https://github.com/garybernhardt/dotfiles/blob/master/.zshrc#L23
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

# save history to specific file
# source: https://github.com/garybernhardt/dotfiles/blob/master/.zshrc#L24
export HISTFILE=$HOME/.zsh_history

# history search with globbing
# source: https://unix.stackexchange.com/questions/30168/how-to-enable-reverse-search-in-zsh#comment40870_30169
# bindkey '^R' history-incremental-pattern-search-backward

# move to next match in history search
# source: https://www.gnu.org/software/emacs/manual/html_node/emacs/Repeat-Isearch.html
# ^R

# history search for last search string
# source: https://www.gnu.org/software/emacs/manual/html_node/emacs/Repeat-Isearch.html
# ^R^R

# filter history backward/forward with substring
# source: https://unix.stackexchange.com/a/461262
# bindkey '^P' history-beginning-search-backward
# bindkey '^N' history-beginning-search-forward

# search history shortcuts
# source: https://stackoverflow.com/a/14469720/11197595
# $ !vi<tab>
# $ vi ~/.zshrc
# $ !?zshrc
# $ vi ~/.zshrc

# execute last command
# source: http://www.geekmind.net/2011/01/shortcuts-to-improve-your-bash-zsh.html
# $ !!

# open current line in $EDITOR
# source: https://unix.stackexchange.com/a/34251 autoload -z edit-command-line
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# switch back to suspended program
ctrl_z () {
  BUFFER="fg"
  zle accept-line
}
zle -N ctrl_z
bindkey '^Z' ctrl_z

# keyboard shortcuts
# ^A - beginning of the line
# ^E - end of the line
# alt + b - move one word backward
# alt + f - move one word forward
# ^U - delete whole line
# ^K - delete after cursor
# ^W - delete word before cursor
# alt + d - delete word after cursor
# ^R - search history
# ^G - escape from search
# ^_ - undo last change
# ^L - clear screen
# ^C - kill process
# ^Z - suspend process

# colored man pages
export LESS_TERMCAP_md=$'\e[01;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;32m'
export LESS_TERMCAP_se=$'\e[0m'

# vgrep
compdef vgrep=rg

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# fzf
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# nnn
# export NNN_OPTS='eH'
# export NNN_COLORS='6277'
# export NNN_BMS='d:~/dev;D:~/Documents;c:~/dotfiles;s:~/dotfiles/.local/bin'
# export NNN_TRASH=1

# rbenv
export PATH=~/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# yarn
export PATH=~/.yarn/bin:$PATH

# go
export GOBIN=/usr/local/bin

# linuxbrew
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# z
. /home/linuxbrew/.linuxbrew/etc/profile.d/z.sh

# load local zshrc
if [[ -r ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
