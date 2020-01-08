#!/bin/bash

# os detection
if [[ $OSTYPE == "linux-gnu" ]]; then
    distribution=$(grep "^ID" /etc/os-release | awk -F '=' '{ print $2 }')
    if [[ $distribution == "arch" || $distribution == "ubuntu" ]]; then
        OS="$distribution"
    else
        dialog --title "Error: Distribution not supported" --clear \
            --msgbox "Sorry, Arch and Ubuntu are only supported Linux distributions. Feel free to open pull request and add your favorite distribution. https://github.com/bartol/dotfiles/issues/new/" 0 0
        clear
        exit 1
    fi
elif [[ $OSTYPE == "darwin"* ]]; then
    OS="macos"
else
    dialog --title "Error: OS not supported" --clear \
        --msgbox "Sorry, Arch, Ubuntu and MacOS are only supported Operating Systems. Feel free to open pull request and add your favorite OS. https://github.com/bartol/dotfiles/issues/new/" 0 0
    clear
    exit 1
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
