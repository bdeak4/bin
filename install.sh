#!/bin/bash

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
if [ "$OSTYPE" == "linux-gnu" ]; then
    distribution=$(grep "^ID" /etc/os-release | awk -F '=' '{ print $2 }')
    if [[ "$distribution" == "arch" || "$distribution" == "ubuntu" ]]; then
        OS="$distribution"
    else
        echo "distribution not supported"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "os not supported"
fi

dialog --title "Welcome" --clear --msgbox "Hey, welcome to Bartol's installer script\nThis script will install my most used programs" 0 0

dialog --title "Disclaimer" --clear --yesno "I am NOT responsible for damage caused by this script. Use at your own risk. Do you accept risk?" 0 0

# shellcheck disable=SC2
if [ "$(echo $?)" != 0 ];then
    dialog --title "cya" --clear --msgbox "It was nice to meet you\n" 0 0
    clear
    exit 1
fi

# user password
password=$(dialog --title "password" --clear --insecure --passwordbox "Input password for curent user:" 0 0 3>&1 1>&2 2>&3 3>&1)

if [ "$(echo "$password" | sudo -Skv 2> /dev/null; echo $?)" != 0 ];then
    dialog --title "Error" --clear --msgbox "Incorrect password\n" 0 0
    clear
    exit 1
fi

preset=$(dialog --title "choose preset" --clear --radiolist "Choose preset for pre-selected values" 0 0 0 \
    1 "development (local) environment" on \
    2 "server (remote) environment" off \
    3>&1 1>&2 2>&3 3>&1)

info ()
{
    dialog --infobox "$1\n" 0 0; sleep 1s
}

install_program ()
{
    # check if program is already installed
    if ! [ -x "$(command -v "$1")" ]; then

        info "installing $1"
        # install it
        if [[ "$2" && "$2" != "install_from_package_manager" ]]; then
            ($2)
        else
            case "$OS" in
                "arch")   echo "$password" | sudo -S pacman -S "$1";;
                "ubuntu") echo "$password" | sudo -S apt-get update && sudo apt-get install "$1";;
                "macos")  brew install "$1";;
            esac
        fi

        # check if installation was successful
        if [ -x "$(command -v "$1")" ]; then
            info "$1 successfuly installed"
            return 0
        else
            info "$1 installation failed"
            exit 1
        fi

    else
        info "$1 already installed"
        return 0
    fi

    # configure program
    if [[ "$3" && "$3" != "no_configuration" ]]; then
        info "configuring $1"
        ($3)
    fi
}

function_exists ()
{
    declare -f -F "$1" > /dev/null
    return $?
}

brew_install ()
{
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

brew_config ()
{
    echo "brew config"
}

curl_install ()
{
    echo "curl install"
}

git_config ()
{
    echo "git config"
}


echo "$required" | while IFS= read -r item; do
    name=$(echo "$item" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $1}')
    install="_install"
    config="_config"

    cmd="install_program $name"
    cmd+=" $(function_exists "$name$install" && echo "$name$install" || echo "install_from_package_manager")"
    cmd+=" $(function_exists "$name$config" && echo "$name$config" || echo "no_config")"

    $cmd
done

clear

echo "Configuration done!"
