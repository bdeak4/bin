### zsh options

# enable colors
autoload -U colors && colors

# enable emacs bindings
bindkey -e

# prompt
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$ZDOTDIR/zsh_history"
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
alias m='neomutt'
alias y='yarn'

# edit line in editor with ctrl-v:
autoload edit-command-line; zle -N edit-command-line
bindkey '^V' edit-command-line

# ctrl z
ctrl_z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N ctrl_z
bindkey '^Z' ctrl_z


### program options

# fzf
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden -g '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="
--color=bg+:#282828,bg:#181818,spinner:#86c1b9,hl:#7cafc2
--color=fg:#b8b8b8,header:#7cafc2,info:#f7ca88,pointer:#86c1b9
--color=marker:#86c1b9,fg+:#e8e8e8,prompt:#f7ca88,hl+:#7cafc2
--bind 'ctrl-a:select-all'
"

[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh

# nnn
export NNN_USE_EDITOR=1
export NNN_TRASH=1
export NNN_CONTEXT_COLORS="4231"
export NNN_BMS="d:$HOME/dev/;D:$HOME/downloads/;c:$HOME/.config/bartol/;s:$HOME/.local/bin/"


### plugins

# zsh-autosuggestions
[ -f "$ZDOTDIR"/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
  && source "$ZDOTDIR"/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
[ -f "$ZDOTDIR"/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source "$ZDOTDIR"/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
