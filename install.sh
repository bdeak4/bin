#!/bin/bash

# os detection
if [[ $OSTYPE == "linux-gnu" ]]; then
    distribution=$(grep "^ID" /etc/os-release | awk -F'=' '{print $2}')
    if [[ $distribution == "arch" || $distribution == "ubuntu" ]]; then
        OS="$distribution"
    else
        if command -v dialog &>/dev/null
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
    if command -v dialog &>/dev/null
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
    echo "$password" | sudo -S pacman -S "$1" --noconfirm &>/dev/null
}

ubuntu()
{
    echo "$password" | sudo -S apt-get update &>/dev/null;echo "$password" | sudo -S apt-get install "$1" -y &>/dev/null
}

macos()
{
    brew install "$1" &>/dev/null
}

install_all_platforms()
{
    case "$OS" in
        "arch")   arch "$1";;
        "ubuntu") ubuntu "$1";;
        "macos")  macos "$1";;
    esac
}

is_already_installed()
{
    if command -v "$1" &>/dev/null
    then
        if [[ $2 == '--dialog' ]]; then
            if command -v dialog &>/dev/null
            then
                dialog --title "$1" --infobox "Already installed.\n" 0 0
                sleep 1
            else
                echo "$1" already installed
            fi
        fi
        echo "$1" >> ~/.config/bartol/already_installed
        return 0
    else
        return 1
    fi
}

is_install_successful()
{
    if command -v "$1" &>/dev/null
    then
        if [[ $2 == '--dialog' ]]; then
            if command -v dialog &>/dev/null
            then
                dialog --title "$1" --infobox "Install succesful.\n" 0 0
                sleep 1
            else
                echo "$1" install succesful
            fi
        fi
        echo "$1" >> ~/.config/bartol/successful_installs
        return 0
    else
        if [[ $2 == '--dialog' ]]; then
            if command -v dialog &>/dev/null
            then
                dialog --title "$1" --infobox "Install failed.\n" 0 0
                sleep 1
            else
                echo "$1" install failed
            fi
        fi
        echo "$1" >> ~/.config/bartol/failed_installs
        if [[ $3 == '--required' ]]; then
            exit 1
        fi
        return 1
    fi
}

installing_message()
{
    if [[ $2 == '--required' ]]; then
        if command -v dialog &>/dev/null
        then
            dialog --title "$1" --infobox "Installing $1... (required to run script)\n" 0 0
        else
            echo installing "$1"... "(required to run script)"
        fi
    else
        if command -v dialog &>/dev/null
        then
            dialog --title "$1" --infobox "Installing $1...\n" 0 0
        else
            echo installing "$1"...
        fi
    fi
}

ask_for_password()
{
    if command -v dialog &>/dev/null
    then
        password=$(dialog --title "Password" --clear --insecure \
            --passwordbox "Enter password current user:" 8 40 \
            3>&1 1>&2 2>&3 3>&1)
    else
        read -r -s -p "Password:" password
    fi

    # verify
    if ! echo "$password" | sudo -Skv &>/dev/null
    then
        if command -v dialog &>/dev/null
        then
            dialog --title "Error: User login" --clear \
                --msgbox "Password is incorrect or user doesn't have root privileges." 6 35
            clear
        else
            echo Error: User login
            echo "Password is incorrect or user doesn't have root privileges."
        fi
        exit 1
    fi
}

# prep for script
mkdir -p ~/.config/bartol

# program stats init
touch ~/.config/bartol/successful_installs
touch ~/.config/bartol/failed_installs
touch ~/.config/bartol/already_installed

# install required programs
# brew
if [[ $OS == "macos" ]]; then
    if ! is_already_installed brew
    then
        installing_message brew
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        is_install_successful brew --dialog --required
    fi
fi

# dialog
if ! is_already_installed dialog
then
    installing_message dialog
    if [[ $OS == "arch" || $OS == "ubuntu"  && ! $password ]]; then
        ask_for_password
    fi
    install_all_platforms dialog
    is_install_successful dialog --dialog --required
fi

# git
if ! is_already_installed git
then
    installing_message git
    if [[ $OS == "arch" || $OS == "ubuntu" && ! $password ]]; then
        ask_for_password
    fi
    install_all_platforms git
    is_install_successful git --dialog --required
fi

# curl
if ! is_already_installed curl
then
    installing_message curl
    if [[ $OS == "arch" || $OS == "ubuntu" && ! $password ]]; then
        ask_for_password
    fi
    install_all_platforms curl
    is_install_successful curl --dialog --required
fi

# welcome message
dialog --title "Welcome" --clear \
    --msgbox "This script was made after realizing fragility of my development environment and data, how I am not ready for unexpected accident that may be just around the corner. It's better to spend few hours now than deal with headaches when you, by accident, spill coffee on your laptop. You never know. ¯\_(ツ)_/¯" 0 0

# terms of service
if ! dialog --title "Terms of Service" --clear --yes-label "Accept" --no-label "Decline" \
    --yesno "You have to keep in mind that I made this for myself as a weekend project. There are no tests and things can go wrong. I warned you. Use at your own risk and don't blame me later." 0 0
then
    # TODO add lyrics
    dialog --title "Odjeb je lansiran" --clear \
        --msgbox "" 0 0
    clear
    exit 1
fi

# user password
if [[ ! $password ]]; then
    ask_for_password
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
"4    neovim                      text editor                    on on  "
"5    nnn                         file manager                   on on  "
"6    fzf                         fuzzy finder                   on on  "
"7    tmux                        terminal multiplexer           off on "
"8    neomutt                     email client                   off off"
"9    zathura                     pdf viewer                     off off"
"10   xsv                         csv tools                      off off"
"11   pastel                      color tools                    off off"
"12   youtube-dl                  youtube downloader             off off"
"13   autojump                    directory navigation           on on  "
"14   rg                          better grep                    on on  "
"15   fd                          better find                    on on  "
"16   exa                         better ls                      off off"
"17   bat                         better cat                     off off"
"18   asciinema                   record terminal                off off"
"19   htop                        process viewer                 off on "
"20   bandwhich                   network utilization            off off"
"21   hyperfine                   cmd benchmark tool             off off"
"22   neofetch                    system info                    off off"
"23   bspwm                       tiling window manager, linux   off off"
"24   sxhkd                       hotkey daemon, linux           off off"
"25   polybar                     status bar, linux              off off"
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

# clone config repository
dialog --title "Config" --infobox "Cloning config repository.\n" 0 0

git clone --recursive https://github.com/bartol/config ~/.config/bartol &>/dev/null

# program install functions
zsh_install()
{
    install_all_platforms zsh
    echo "$password" | sudo -S chsh -s "$(command -v zsh)" "$USER"

    mkdir -p ~/.config/zsh
    ln -s ~/.config/bartol/zsh/.zprofile ~
    ln -s ~/.config/bartol/zsh/.zshrc ~/.config/zsh
    ln -s ~/.config/bartol/zsh/plugins ~/.config/zsh
    ln -s ~/.config/bartol/zsh/history ~/.config/zsh

    sudo --login --user "$USER"

    is_install_successful zsh --dialog
}

alacritty_install()
{
    install_all_platforms alacritty

    mkdir -p ~/.config/alacritty
    ln -s ~/.config/bartol/alacritty/alacritty.yml ~/.config/alacritty

    is_install_successful alacritty --dialog
}

firefox-developer-edition_install()
{
    # there is no firefox developer edition in ubuntu packages
    if [[ $OS == "ubuntu" ]]; then
        firefox_package="firefox"
    else
        firefox_package="firefox-developer-edition"
    fi

    install_all_platforms $firefox_package

    is_install_successful $firefox_package --dialog
}

neovim_install()
{
    if ! is_already_installed "nvim" --dialog
    then
        install_all_platforms neovim

        mkdir -p ~/.config/nvim
        ln -s ~/.config/bartol/nvim/init.vim ~/.config/nvim
        curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        nvim -c "PlugInstall" -c ":qa"

        is_install_successful nvim --dialog
    fi
}

# call program functions for all selected, not-installed programs
IFS=' ' read -ra selected_programs_arr <<< "$selected_programs"

for program_id in "${selected_programs_arr[@]}"
do
    program=${programs[program_id - 1]}
    program_name=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $2}')
    program_function_sufix="_install"

    if ! is_already_installed "$program_name" --dialog
    then
        ("$program_name$program_function_sufix" &>/dev/null)
    fi
done

clear

cat ~/.config/bartol/successful_installs
cat ~/.config/bartol/failed_installs
cat ~/.config/bartol/already_installed

rm ~/.config/bartol/successful_installs
rm ~/.config/bartol/failed_installs
rm ~/.config/bartol/already_installed

exit 0
