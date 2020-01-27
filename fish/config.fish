set -g fish_prompt_pwd_dir_length 0

function fish_prompt
    printf '%s' (set_color red) [ (set_color yellow) $USER \
    (set_color green) @ (set_color blue) (prompt_hostname) ' ' \
    (set_color magenta) (prompt_pwd) (set_color red) ] \
    (set_color normal) (test $USER = 'root' && echo -n '#' || echo -n '$') ' '
end

if status --is-interactive
    abbr --add --global g git
    abbr --add --global v nvim
    abbr --add --global t tmux
    abbr --add --global y yarn
end

set --export EDITOR nvim

if command -v fzf >/dev/null
    set --export FZF_DEFAULT_COMMAND "rg --files --follow --hidden -g '!.git'"
    set --export FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set --export FZF_DEFAULT_OPTS \
    "--color=bg+:#282828,bg:#181818,spinner:#86c1b9,hl:#7cafc2
    --color=fg:#b8b8b8,header:#7cafc2,info:#f7ca88,pointer:#86c1b9
    --color=marker:#86c1b9,fg+:#e8e8e8,prompt:#f7ca88,hl+:#7cafc2
    --bind 'ctrl-a:select-all'"
end

if command -v nnn >/dev/null
    set --export NNN_TRASH 1
    set --export NNN_CONTEXT_COLORS '4231'
    set --export NNN_BMS \
    "d:$HOME/dev/;D:$HOME/downloads/;c:$HOME/config/;s:$HOME/config/scripts"
end
