# prompt
set -g fish_prompt_pwd_dir_length 0

function fish_prompt
    printf '%s' (set_color red) [ (set_color yellow) $USER \
    (set_color green) @ (set_color blue) (prompt_hostname) ' ' \
    (set_color magenta) (prompt_pwd) (set_color red) ] \
    (set_color normal) (test $USER = 'root' && echo -n '#' || echo -n '$') ' '
end

# abbreviations
abbr -a g git
abbr -a n nnn
abbr -a v nvim
abbr -a t tmux
abbr -a y yarn
abbr -a m neomutt

# environment
set -x PATH ~/.local/bin $PATH

set -x EDITOR nvim
set -x PAGER less

if set -q SSH_TTY
    set -x BROWSER links
else
    switch (uname)
    case Linux
        set -x BROWSER 'firefox-developer-edition'
    case Darwin
        set -x BROWSER 'Firefox Developer Edition'
    case '*'
        set -x BROWSER links
    end
end

# fzf
set -x FZF_DEFAULT_COMMAND "rg --files --follow --hidden -g '!.git'"
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_DEFAULT_OPTS \
"--color=bg+:#282828,bg:#181818,spinner:#86c1b9,hl:#7cafc2
--color=fg:#b8b8b8,header:#7cafc2,info:#f7ca88,pointer:#86c1b9
--color=marker:#86c1b9,fg+:#e8e8e8,prompt:#f7ca88,hl+:#7cafc2
--bind 'ctrl-a:select-all'"

# nnn
set -x NNN_CONTEXT_COLORS '4231'
set -x NNN_BMS "d:~/dev/;D:~/downloads/;c:~/config/;s:~/config/scripts"
set -x NNN_TRASH 1
set -x NNN_USE_EDITOR 1

# pass
source ~/.config/fish/functions/pass.fish-completion

# colored man pages
set -x LESS_TERMCAP_md \e'[01;34m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_so \e'[01;33m'
set -x LESS_TERMCAP_se \e'[0m'

# gnu coreutils on mac
if test (uname) = "Darwin"
    set -x PATH (brew --prefix)/opt/coreutils/libexec/gnubin $PATH
    set -x PATH (brew --prefix)/opt/findutils/libexec/gnubin $PATH
    set -x PATH (brew --prefix)/opt/gnu-tar/libexec/gnubin $PATH
    set -x PATH (brew --prefix)/opt/gnu-sed/libexec/gnubin $PATH
    set -x PATH (brew --prefix)/opt/gnu-indent/libexec/gnubin $PATH
    set -x PATH (brew --prefix)/opt/grep/libexec/gnubin $PATH
    set -x MANPATH (brew --prefix)/opt/coreutils/libexec/gnuman $MANPATH
    set -x MANPATH (brew --prefix)/opt/findutils/libexec/gnuman $MANPATH
    set -x MANPATH (brew --prefix)/opt/gnu-tar/libexec/gnuman $MANPATH
    set -x MANPATH (brew --prefix)/opt/gnu-sed/libexec/gnuman $MANPATH
    set -x MANPATH (brew --prefix)/opt/gnu-indent/libexec/gnuman $MANPATH
    set -x MANPATH (brew --prefix)/opt/grep/libexec/gnuman $MANPATH
end