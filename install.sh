#!/bin/sh

# name                          description                     config directory                platform specific
required="$(cat <<EOF
curl                            http client                     no                              any
git                             version control                 ~                               any
brew                            package manager                 no                              macos
dialog                          this nice screen                no                              any
EOF
)"

# name                          description                     config directory                platform specific               selected
programs="$(cat <<EOF
zsh                             shell                           ~/.config/zsh                   any                             yes,yes
alacritty                       terminal emulator               ~/.config/alacritty             any                             yes,no
firefox-developer-edition       web browser                     ~/.mozilla/firefox              any                             yes,no
nvim                            text editor                     ~/.config/nvim                  any                             yes,yes
nnn                             file manager                    ~/.config/nnn                   any                             yes,yes
fzf                             fuzzy finder                    ~/.config/fzf                   any                             yes,yes
neomutt                         email client                    ~/.config/neomutt               any                             no,no
zathura                         pdf viewer                      ~/.config/zathura               any                             no,no
youtube-dl                      youtube downloader              ~/.config/youtube-dl            any                             no,no
autojump                        faster dir navigation           no                              any                             yes,yes
ripgrep                         better grep                     ~                               any                             yes,yes
fd                              better find                     no                              any                             yes,yes
htop                            process viewer                  no                              any                             no,yes
neofetch                        system info                     ~/.config/neofetch              any                             no,no
bspwm                           tiling window manager           ~/.config/bspwm                 linux                           no,no
sxhkd                           hotkey daemon                   ~/.config/sxhkd                 linux                           no,no
polybar                         status bar                      ~/.config/polybar               linux                           no,no
EOF
)"

# name                          description                     version manager                 selected
languages="$(cat <<EOF
rust                            rust compiler and tooling       rustup                          yes,no
nodejs                          javascript runtime              nvr                             yes,no
yarn                            javascript package manager      n/a                             no,no
deno                            typescript runtime              n/a                             no,no
python                          python interpreter              pyenv                           yes,no
ruby                            ruby interpreter                rbenv                           no,no
EOF
)"

# name                          type                            weights                         italics                         selected
fonts="$(cat <<EOF
Dank Mono                       monospace                       Regular                         yes                             yes,no
Proxima Nova                    sans-serif                      Regular,Light,Semibold,Bold     yes                             yes,no
EOF
)"

# os detection
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    distribution=$(grep "^ID" /etc/os-release | awk -F '=' '{ print $2 }')
    if [[ "$distribution" == "arch" || "$distribution" == "ubuntu" ]]; then
        os="$distribution"
    else
        echo "distribution not supported"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    os="macos"
else
    echo "os not supported"
fi

# package install command
case "$os" in
    "arch")   package_install_command="sudo pacman -S ";;
    "ubuntu") package_install_command="sudo apt-get update && sudo apt-get install ";;
    "macos")  package_install_command="brew install ";;
esac


if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi
