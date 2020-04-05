# prompt
# set -g fish_prompt_pwd_dir_length 0

function fish_prompt
    printf '%s' (set_color red) [ (set_color yellow) $USER \
    (set_color green) @ (set_color blue) (prompt_hostname) ' ' \
    (set_color magenta) (prompt_pwd) (set_color red) ] \
    (set_color normal) (test $USER = 'root' && echo -n '#' || echo -n '$') ' '
end

# function fish_prompt
#     printf '%s' (set_color cyan) (prompt_pwd) (set_color normal) '> '
# end

# abbreviations
abbr -a v vim
abbr -a g git
abbr -a n nnn
abbr -a m mutt
abbr -a t tmux
abbr -a y yarn
abbr -a r rails
abbr -a h heroku

set -x GOOGLE_CHROME_BIN \
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# environment
set -x PATH ~/.local/bin $PATH

set -x EDITOR kak
set -x PAGER less

set -x BROWSER links
if ! set -q SSH_TTY && test (uname) = "Linux"
    set -x BROWSER 'firefox-developer-edition'
end
if ! set -q SSH_TTY && test (uname) = "Darwin"
    set -x BROWSER 'Firefox Developer Edition'
end

# rbenv
# status --is-interactive; and source (rbenv init -|psub)

# ctags
set -x CTAGS \
"--recurse=yes
--exclude=.git
--exclude=vendor
--exclude=node_modules"

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

# rust
set -x PATH ~/.cargo/bin $PATH

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
    set -x MANPATH :(brew --prefix)/opt/coreutils/libexec/gnuman $MANPATH
    set -x MANPATH :(brew --prefix)/opt/findutils/libexec/gnuman $MANPATH
    set -x MANPATH :(brew --prefix)/opt/gnu-tar/libexec/gnuman $MANPATH
    set -x MANPATH :(brew --prefix)/opt/gnu-sed/libexec/gnuman $MANPATH
    set -x MANPATH :(brew --prefix)/opt/gnu-indent/libexec/gnuman $MANPATH
    set -x MANPATH :(brew --prefix)/opt/grep/libexec/gnuman $MANPATH
end

# set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths
