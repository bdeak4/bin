#!/bin/bash

# os detection
if [[ $OSTYPE == "linux-gnu" ]]; then
    distribution=$(grep "^ID" /etc/os-release | awk -F'=' '{print $2}')
    if [[ $distribution == "arch" || $distribution == "ubuntu" ]]; then
        OS="$distribution"
    else
        if command -v dialog
        then
            dialog --title "Error: Distribution not supported" --clear \
                --msgbox "Sorry, Arch and Ubuntu are only supported Linux distributions. Feel free to open pull request and add your favorite distribution. https://github.com/bartol/config/issues/new/" 0 0
        else
            echo Error: Distribution not supported
            printf "Sorry, Arch and Ubuntu are only supported Linux distributions.\nFeel free to open pull request and add your favorite distribution.\nhttps://github.com/bartol/config/issues/new/"
        fi
        exit 1
    fi
elif [[ $OSTYPE == "darwin"* ]]; then
    OS="macos"
else
    if command -v dialog
    then
        dialog --title "Error: OS not supported" --clear \
            --msgbox "Sorry, Arch, Ubuntu and MacOS are only supported Operating Systems. Feel free to open pull request and add your favorite OS. https://github.com/bartol/config/issues/new/" 0 0
    else
        echo Error: OS not supported
        printf "Sorry, Arch, Ubuntu and MacOS are only supported Operating Systems.\nFeel free to open pull request and add your favorite OS.\nhttps://github.com/bartol/config/issues/new/"
    fi
    exit 1
fi

# package install helpers
arch()
{
    echo "$password" | sudo -S pacman -S "$1" --noconfirm >/dev/null
}

ubuntu()
{
    echo "$password" | sudo -S apt-get update >/dev/null;echo "$password" | sudo -S apt-get install "$1" -y >/dev/null
}

macos()
{
    brew install "$1" >/dev/null
}

# install required programs
if [[ $OS == "macos" && ! $(command -v brew) ]]; then
    echo "Installing homebrew (required to run script)"

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    if ! command -v brew
    then
        echo "Error: homebrew installation failed"
        exit 1
    fi
fi

install_required()
{
    if ! command -v "$1"
    then
        echo "Installing $1 (required to run script)"

        if [[ $OS == "arch" || $OS == "ubuntu" ]]; then
            read -r -s -p "Password:" password
        fi
        case "$OS" in
            "arch")   arch "$1";;
            "ubuntu") ubuntu "$1";;
            "macos")  macos "$1";;
        esac

        if ! command -v "$1"
        then
            echo "Error: $1 installation failed"
            exit 1
        fi
    fi
}
install_required dialog
install_required git

# welcome message
dialog --title "Welcome" --clear \
    --msgbox "This script was made after realizing fragility of my development environment and data, how I am not ready for unexpected accident that may be just around the corner. It's better to spend few hours now than deal with headaches when you, by accident, spill coffee on your laptop. You never know. ¯\_(ツ)_/¯" 0 0

# terms of service
if ! dialog --title "Terms of Service" --clear --yes-label "Accept" --no-label "Decline" \
    --yesno "You have to keep in mind that I made this for myself as a weekend project. There are no tests and things can go wrong. I warned you. Use at your own risk and don't blame me later." 0 0
then
    # TODO
    dialog --title "Odjeb je lansiran" --clear \
        --msgbox "" 0 0
    clear
    exit 1
fi

# user password
if [[ ! $password ]]; then
    password=$(dialog --title "Password" --clear --insecure \
        --passwordbox "Enter password current user:" 8 40 \
        3>&1 1>&2 2>&3 3>&1)

    if ! echo "$password" | sudo -Skv &>/dev/null
    then
        dialog --title "Error: User login" --clear \
            --msgbox "Password is incorrect or user doesn't have root privileges." 6 35
                    clear
                    exit 1
    fi
fi

# default selection preset
preset=$(dialog --title "Default selection" --clear \
    --radiolist "Choose preset for pre-selected values:" 0 0 0 \
    1 "development (local) environment" on \
    2 "server (remote) environment" off \
    3>&1 1>&2 2>&3 3>&1)

# select programs
# id  name                        description                    selected
programs=(
"1    zsh                         shell                          on on  "
"2    alacritty                   terminal emulator              on off "
"3    firefox-developer-edition   web browser                    on off "
"4    nvim                        text editor                    on on  "
"5    nnn                         file manager                   on on  "
"6    fzf                         fuzzy finder                   on on  "
"7    tmux                        terminal multiplexer           off on "
"8    neomutt                     email client                   off off"
"9    zathura                     pdf viewer                     off off"
"10   youtube-dl                  youtube downloader             off off"
"11   autojump                    directory navigation           on on  "
"12   rg                          better grep                    on on  "
"13   fd                          better find                    on on  "
"14   exa                         better ls                      off off"
"15   bat                         better cat                     off off"
"16   htop                        process viewer                 off on "
"17   neofetch                    system info                    off off"
"18   bspwm                       tiling window manager, linux   off off"
"19   sxhkd                       hotkey daemon, linux           off off"
"20   polybar                     status bar, linux              off off"
)

programs_args=()
for program in "${programs[@]}"; do
    index=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $1}')
    name=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $2}')
    desc=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $3}')
    selection=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $4}')
    selected=$(echo "$selection" | awk -F'[[:space:]]' -v preset="$preset" '{print $preset}')
    programs_args+=("$index" "$name ($desc)" "$selected")
done

selected_programs=$(dialog --title "Programs" --clear \
    --checklist "Choose programs to install:" 0 0 0 "${programs_args[@]}" \
    3>&1 1>&2 2>&3 3>&1)

# prep for install
dialog --title "Install" --infobox "Preparing for install.\n" 0 0
sleep 1

cd ~ || exit
mkdir config_tmp

# clone config repository
dialog --title "Install" --infobox "Cloning config repository.\n" 0 0

git clone --recursive https://github.com/bartol/config config_tmp &>/dev/null

# program stats init
touch config_tmp/successful_installs
touch config_tmp/failed_installs
touch config_tmp/already_installed

# check if program is already installed
is_already_installed()
{
    if [[ $OS == "arch" ]]; then
        echo "$password" | sudo -S pacman -S "$1" --noconfirm >/dev/null
    fi
}

ubuntu()
{
    if [[ $OS == "ubuntu" ]]; then
        echo "$password" | sudo -S apt-get update >/dev/null;echo "$password" | sudo -S apt-get install "$1" -y >/dev/null
    fi
}

macos()
{
    if [[ $OS == "macos" ]]; then
        brew install "$1" >/dev/null
    fi
}


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
