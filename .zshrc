autoload -Uz compinit && compinit
PROMPT="[%n@%m %~]%(#.#.$) "
export EDITOR=vi
export PATH=~/.local/bin:$PATH
bindkey -e
stty -ixon
alias vi="vim"
alias g="git"
setopt autocd
setopt sharehistory
setopt histignorespace
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history

# case insensitive path completion
zstyle ":completion:*" matcher-list \
	"m:{[:lower:][:upper:]}={[:upper:][:lower:]}" \
	"m:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*" \
	"m:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*" \
	"m:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*"

# open current line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line

# switch back to suspended program
ctrl_z() {
	BUFFER="fg"
	zle accept-line
}
zle -N ctrl_z
bindkey "^Z" ctrl_z

# go
export PATH=/usr/local/go/bin:$PATH
export GOPATH=~/.go
export PATH=~/.go/bin:$PATH

# rust
export PATH=~/.cargo/bin:$PATH
