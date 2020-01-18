#!/bin/bash

# os detection
if [[ $OSTYPE == "linux-gnu" ]]; then
    distribution=$(grep "^ID=" /etc/os-release | awk -F'=' '{print $2}')
    if [[ $distribution == "arch" ]]; then
        OS="$distribution"
    else
        clear
        printf "\n    Error: Distribution not supported\n
    Sorry, Arch is the only supported Linux distributions.
    Feel free to open pull request and add your favorite distribution.
    https://github.com/bartol/config/issues/new/\n\n"
        exit 1
    fi
elif [[ $OSTYPE == "darwin"* ]]; then
    OS="macos"
else
    clear
    printf "\n    Error: OS not supported\n
    Sorry, Arch and MacOS are only supported Operating Systems.
    Feel free to open pull request and add your favorite OS.
    https://github.com/bartol/config/issues/new/\n\n"
    exit 1
fi

# messages
clear
printf "\n    Welcome\n
    This script was made after realizing fragility of my development
    environment and data, how I am not ready for unexpected accident
    that may be just around the corner. It's better to spend few hours
    now than deal with headaches when you, by accident, spill coffee
    on your laptop. You never know. ¯\_(ツ)_/¯\n\n"
read -n 1 -s -r -p "    Press any key to continue "

clear
printf "\n    Terms of Service\n
    You have to keep in mind that I made this for myself as a weekend
    project. There are no tests and things can go wrong. I warned you.
    Use at your own risk and don't blame me later.\n\n"
read -n 1 -s -r -p "    Press any key to continue "

# choose install options
options=(
    "zsh"
    "neovim"
    "alacritty"
    "nnn"
    "fzf"
)

descriptions=(
    "shell"
    "text editor"
    "terminal emulator"
    "file manager"
    "fuzzy finder"
)

menu() {
    clear
    printf "\n    Available options:\n\n"
    for i in "${!options[@]}"; do
        printf "      %d) [%s] %s (%s)\n" \
            $((i+1)) "${choices[i]:- }" "${options[i]}" "${descriptions[i]}"
    done
    echo
}

prompt="    Number + ENTER to (un)check an option, ENTER to continue "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    if [[ "$num" == *[[:digit:]]* ]] && (( num > 0 && num <= ${#options[@]} ))
    then
        ((num--))

        if [[ "${choices[num]}" ]]; then
            choices[num]=""
        else
            choices[num]="x"
        fi
    fi
done

# exit if choices are empty
if [ ${#choices[@]} -eq 0 ]; then
    clear
    printf "\n    Error: No checked options\n\n"
    exit 1
fi

# install helpers
install_with_pacman()
{
    sudo pacman -S "$1" --noconfirm &>/dev/null
}

install_with_brew()
{
    brew install "$1" &>/dev/null
}

install_with_brewcask()
{
    brew cask install "$1" &>/dev/null
}

# cleanup cursor and tmp files
function cleanup() {
    tput cnorm
    rm -f "$successful_installs" "$failed_installs" "$already_installed"
}
trap cleanup EXIT

# hide cursor while installing
tput civis

# script setup
clear
printf "\n    Setup\n\n"

echo "    Starting time counter..."
start_time=$(date +%s)
sleep 0.5

echo "    Creating temp files..."
successful_installs=$(mktemp /tmp/successful_installs.XXXXXX)
failed_installs=$(mktemp /tmp/failed_installs.XXXXXX)
already_installed=$(mktemp /tmp/already_installed.XXXXXX)
sleep 0.5

echo "    Installing script dependencies..."
if [[ $OS == "macos" ]]; then
    if ! command -v brew &>/dev/null; then
        /usr/bin/ruby -e "$(curl -fsSL \
            https://raw.githubusercontent.com/Homebrew/install/master/install)"

        if command -v brew &>/dev/null; then
            echo brew >> "$successful_installs"
        else
            echo brew >> "$failed_installs"
            exit 1
        fi
    fi
fi
if ! command -v git &>/dev/null; then
    case "$OS" in
        "arch")   install_with_pacman git;;
        "macos")  install_with_brew git;;
    esac

    if command -v git &>/dev/null; then
        echo git >> "$successful_installs"
    else
        echo git >> "$failed_installs"
        exit 1
    fi
fi
if ! command -v curl &>/dev/null; then
    case "$OS" in
        "arch")   install_with_pacman curl;;
        "macos")  install_with_brew curl;;
    esac

    if command -v curl &>/dev/null; then
        echo curl >> "$successful_installs"
    else
        echo curl >> "$failed_installs"
        exit 1
    fi
fi
sleep 1

echo "    Cloning config repository..."
git clone https://github.com/bartol/config \
    "$HOME"/.config/bartol &>/dev/null

# install functions
zsh_install()
{
    if ! command -v zsh &>/dev/null; then
        echo "    Installing..."
        case "$OS" in
            "arch")   install_with_pacman zsh;;
            "macos")  install_with_brew zsh;;
        esac

        if command -v zsh &>/dev/null; then
            echo "    Install successful."
            echo zsh >> "$successful_installs"
            sleep 1
        else
            echo "    Install failed."
            echo zsh >> "$failed_installs"
            sleep 1
        fi
    else
        echo "    Already installed."
        echo zsh >> "$already_installed"
        sleep 1
    fi

    echo "    Configuring..."
    echo "    Changing shell."
    sudo chsh -s "$(command -v zsh)" "$USER"

    echo "    Creating config files."
    mkdir -p "$HOME"/.config/zsh
    ln -s "$HOME"/.config/bartol/zsh/.zprofile "$HOME"
    ln -s "$HOME"/.config/bartol/zsh/.zshrc "$HOME"/.config/zsh
    touch "$HOME"/.config/zsh/history

    echo "    Installing plugins."
    mkdir -p "$HOME"/.config/zsh/plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$HOME"/.config/zsh/plugins/zsh-autosuggestions &>/dev/null
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "$HOME"/.config/zsh/plugins/zsh-syntax-highlighting &>/dev/null
}

alacritty_install()
{
    if ([[ $OS != "macos" ]] &&
        ! command -v alacritty &>/dev/null) ||
        ([[ $OS == "macos" ]] &&
        ! brew cask list | grep -q alacritty); then
        echo "    Installing..."
        case "$OS" in
            "arch")   install_with_pacman alacritty;;
            "macos")  install_with_brewcask alacritty;;
        esac

        if command -v alacritty &>/dev/null; then
            echo "    Install successful."
            echo alacritty >> "$successful_installs"
            sleep 1
        else
            echo "    Install failed."
            echo alacritty >> "$failed_installs"
            sleep 1
        fi
    else
        echo "    Already installed."
        echo alacritty >> "$already_installed"
        sleep 1
    fi

    echo "    Configuring..."
    echo "    Creating config files."
    mkdir -p "$HOME"/.config/alacritty
    ln -s "$HOME"/.config/bartol/alacritty/alacritty.yml "$HOME"/.config/alacritty
    sleep 1
}

neovim_install()
{
    if ! command -v nvim &>/dev/null; then
        echo "    Installing..."
        case "$OS" in
            "arch")   install_with_pacman neovim;;
            "macos")  install_with_brew neovim;;
        esac

        if command -v nvim &>/dev/null; then
            echo "    Install successful."
            echo neovim >> "$successful_installs"
            sleep 1
        else
            echo "    Install failed."
            echo neovim >> "$failed_installs"
            sleep 1
        fi
    else
        echo "    Already installed."
        echo neovim >> "$already_installed"
        sleep 1
    fi

    echo "    Configuring..."
    echo "    Creating config files."
    mkdir -p "$HOME"/.config/nvim
    ln -s "$HOME"/.config/bartol/nvim/init.vim "$HOME"/.config/nvim
    curl -fLo "$HOME"/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
        &>/dev/null

    echo "    Installing plugins."
    nvim -V0 -c "PlugInstall" -c ":qa" &>/dev/null
    sleep 1
}

nnn_install()
{
    if ! command -v nnn &>/dev/null; then
        echo "    Installing..."
        case "$OS" in
            "arch")   install_with_pacman nnn;;
            "macos")  install_with_brew nnn;;
        esac

        if command -v nnn &>/dev/null; then
            echo "    Install successful."
            echo nnn >> "$successful_installs"
            sleep 1
        else
            echo "    Install failed."
            echo nnn >> "$failed_installs"
            sleep 1
        fi
    else
        echo "    Already installed."
        echo nnn >> "$already_installed"
        sleep 1
    fi
}

fzf_install()
{
    if ! command -v fzf &>/dev/null; then
        echo "    Installing..."
        case "$OS" in
            "arch")   install_with_pacman fzf;;
            "macos")  install_with_brew fzf; "$(brew --prefix)"/opt/fzf/install;;
        esac

        if command -v fzf &>/dev/null; then
            echo "    Install successful."
            echo fzf >> "$successful_installs"
            sleep 1
        else
            echo "    Install failed."
            echo fzf >> "$failed_installs"
            sleep 1
        fi
    else
        echo "    Already installed."
        echo fzf >> "$already_installed"
        sleep 1
    fi
}

# run install functions
for i in "${!options[@]}"; do
    if [[ "${choices[i]}" ]]; then
        clear
        printf "\n    %s\n\n" "${options[i]}"

        ("${options[i]}_install")
        echo
    fi
done

# script stats
clear
printf "\n    Stats\n\n"

if  [ -s "$successful_installs" ]; then
    printf "    Successful installs:\n\n"
    awk '{ print "      - " $0 }' "$successful_installs"
    echo
fi
if  [ -s "$failed_installs" ]; then
    printf "    Failed installs:\n\n"
    awk '{ print "      - " $0 }' "$failed_installs"
    echo
fi
if  [ -s "$already_installed" ]; then
    printf "    Already installed:\n\n"
    awk '{ print "      - " $0 }' "$already_installed"
    echo
fi

# end time counter
end_time=$(date +%s)

# elapsed time
total_time=$((end_time - start_time))

days=$(( total_time / 60 / 60 / 24 ))
hours=$(( total_time / 60 / 60 % 24 ))
minutes=$(( total_time / 60 % 60 ))
seconds=$(( total_time % 60 ))

(( days > 0 )) && time+="${days}d "
(( hours > 0 )) && time+="${hours}h "
(( minutes > 0 )) && time+="${minutes}m "
time+="${seconds}s"

printf "    Elapsed time: %s\n\n" "$time"

exit 0
