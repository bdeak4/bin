set -g fish_prompt_pwd_dir_length 0

function fish_prompt
    printf '%s' (set_color red) [ (set_color yellow) $USER \
    (set_color green) @ (set_color blue) (prompt_hostname) ' ' \
    (set_color magenta) (prompt_pwd) (set_color red) ] \
    (set_color normal) (test $USER = 'root' && echo -n '#' || echo -n '$') ' '
end

abbr -a g git
abbr -a v nvim
abbr -a t tmux
abbr -a y yarn

set -x EDITOR nvim
set -x PAGER less

if set -q SSH_TTY
  set -x BROWSER links
else
  set -x BROWSER 'Firefox Developer Edition'
end

if command -v fzf >/dev/null
    set -x FZF_DEFAULT_COMMAND "rg --files --follow --hidden -g '!.git'"
    set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -x FZF_DEFAULT_OPTS \
    "--color=bg+:#282828,bg:#181818,spinner:#86c1b9,hl:#7cafc2
    --color=fg:#b8b8b8,header:#7cafc2,info:#f7ca88,pointer:#86c1b9
    --color=marker:#86c1b9,fg+:#e8e8e8,prompt:#f7ca88,hl+:#7cafc2
    --bind 'ctrl-a:select-all'"
end

if command -v nnn >/dev/null
    set -x NNN_USE_EDITOR 1
    set -x NNN_TRASH 1
    set -x NNN_CONTEXT_COLORS '4231'
    set -x NNN_BMS \
    "d:$HOME/dev/;D:$HOME/downloads/;c:$HOME/config/;s:$HOME/config/scripts"
end

# colored man pages
set -x LESS_TERMCAP_mb \e'[01;31m'
set -x LESS_TERMCAP_md \e'[01;38;5;74m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_so \e'[38;5;148m'
set -x LESS_TERMCAP_se \e'[0m'
