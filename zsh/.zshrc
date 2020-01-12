# enable colors
autoload -U colors && colors

# prompt
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$ZDOTDIR/history"
setopt append_history

# autocomplete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# aliases
alias g='git'
alias v='nvim'
alias t='tmux'
alias y='yarn'

# fzf
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden -g '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_gen_fzf_default_opts() {

local color00='#181818'
local color01='#282828'
local color02='#383838'
local color03='#585858'
local color04='#b8b8b8'
local color05='#d8d8d8'
local color06='#e8e8e8'
local color07='#f8f8f8'
local color08='#ab4642'
local color09='#dc9656'
local color0A='#f7ca88'
local color0B='#a1b56c'
local color0C='#86c1b9'
local color0D='#7cafc2'
local color0E='#ba8baf'
local color0F='#a16946'

export FZF_DEFAULT_OPTS="
  --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
  --bind 'ctrl-a:select-all'
"

}

_gen_fzf_default_opts

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# nnn

# bookmarks
export NNN_BMS='d:~/dev/;D:~/downloads/;c:~/.config/;s:~/scripts/'

# different colors for every context
export NNN_CONTEXT_COLORS='4231'

# open text files in text editor
export NNN_USE_EDITOR=1

# move files in trash instead of deleting
export NNN_TRASH=1

# zsh-autosuggestions
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
