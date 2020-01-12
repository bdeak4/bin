#!/bin/bash

# start time counter
start_time=$(date +%s)

# os detection
if [[ $OSTYPE == "linux-gnu" ]]; then
    distribution=$(grep "^ID=" /etc/os-release | awk -F'=' '{print $2}')
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
                sleep 2
            else
                echo "$1" already installed
            fi
        fi
        if [[ $3 != '--nowrite' ]]; then
            echo "$1" >> "$HOME"/.config/bartol/already_installed
        fi
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
                sleep 2
            else
                echo "$1" install succesful
            fi
        fi
        echo "$1" >> "$HOME"/.config/bartol/successful_installs
        return 0
    else
        if [[ $2 == '--dialog' ]]; then
            if command -v dialog &>/dev/null
            then
                dialog --title "$1" --infobox "Install failed.\n" 0 0
                sleep 2
            else
                echo "$1" install failed
            fi
        fi
        echo "$1" >> "$HOME"/.config/bartol/failed_installs
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

function_exists() {
    declare -f -F "$1" &>/dev/null
    return $?
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
mkdir -p "$HOME"/.config/bartol

# program stats init
touch "$HOME"/.config/bartol/successful_installs
touch "$HOME"/.config/bartol/failed_installs
touch "$HOME"/.config/bartol/already_installed

# install required programs
# brew
if [[ $OS == "macos" ]]; then
    if ! is_already_installed brew --nodialog --nowrite
    then
        installing_message brew --required
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        is_install_successful brew --dialog --required
    fi
fi

# dialog
if ! is_already_installed dialog --nodialog --nowrite
then
    installing_message dialog --required
    if [[ $OS == "arch" || $OS == "ubuntu" ]]; then
        if ! [[ $password ]]; then
            ask_for_password
        fi
    fi
    install_all_platforms dialog
    is_install_successful dialog --dialog --required
fi

# git
if ! is_already_installed git --nodialog --nowrite
then
    installing_message git --required
    if [[ $OS == "arch" || $OS == "ubuntu" ]]; then
        if ! [[ $password ]]; then
            ask_for_password
        fi
    fi
    install_all_platforms git
    is_install_successful git --dialog --required
fi

# curl
if ! is_already_installed curl --nodialog --nowrite
then
    installing_message curl --required
    if [[ $OS == "arch" || $OS == "ubuntu" ]]; then
        if ! [[ $password ]]; then
            ask_for_password
        fi
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
if ! [[ $password ]]; then
    ask_for_password
fi

# default selection preset
preset=$(dialog --title "Default selection" --clear \
    --radiolist "Choose preset for pre-selected values:" 0 0 0 \
    1 "development (local) environment" on \
    2 "server (remote) environment" off \
    3>&1 1>&2 2>&3 3>&1)

# select programs
# package                    bin                         description             platforms           selected
programs=(
"zsh                         zsh                         shell                   arch ubuntu macos   on on  "
"alacritty                   alacritty                   terminal emulator       arch ubuntu macos   on off "
"firefox_developer_edition   firefox-developer-edition   web browser             arch macos          on off "
# "firefox                     firefox                     web browser             ubuntu              on off "
"neovim                      nvim                        text editor             arch ubuntu macos   on on  "
"nnn                         nnn                         file manager            arch ubuntu macos   on on  "
"fzf                         fzf                         fuzzy finder            arch ubuntu macos   on on  "
"pass                        pass                        password manager        arch ubuntu macos   on off "
"tmux                        tmux                        terminal multiplexer    arch ubuntu macos   off on "
"neomutt                     neomutt                     email client            arch ubuntu macos   off off"
"hub                         hub                         github cli              arch ubuntu macos   on off "
"ffsend                      ffsend                      firefox send cli        arch macos          on off "
# "zathura                     zathura                     pdf viewer              arch ubuntu         off off"
"xsv                         xsv                         csv tools               arch ubuntu macos   off off"
"pastel                      pastel                      color tools             arch ubuntu macos   off off"
"bcal                        bcal                        calculator              arch ubuntu macos   off off"
"youtube_dl                  youtube-dl                  youtube downloader      arch ubuntu macos   off off"
"autojump                    autojump                    directory navigation    arch ubuntu macos   on on  "
"ripgrep                     rg                          better grep             arch ubuntu macos   on on  "
"fd                          fd                          better find             arch macos          on off "
"fd-find                     fdfind                      better find             ubuntu              on off "
"exa                         exa                         better ls               arch ubuntu macos   off off"
"bat                         bat                         better cat              arch ubuntu macos   off off"
"asciinema                   asciinema                   record terminal         arch ubuntu macos   off off"
"htop                        htop                        process viewer          arch ubuntu macos   off on "
"bandwhich                   bandwhich                   network utilization     arch ubuntu macos   off off"
"hyperfine                   hyperfine                   cmd benchmark tool      arch ubuntu macos   off off"
"trash-cli                   trash                       trashcan                arch ubuntu macos   on on  "
"neofetch                    neofetch                    system info             arch ubuntu macos   off off"
# "bspwm                       bspwm                       tiling window manager   arch ubuntu         off off"
# "sxhkd                       sxhkd                       hotkey daemon           arch ubuntu         off off"
# "polybar                     polybar                     status bar              arch ubuntu         off off"
# "xclip                       xclip                       access clipboard        arch ubuntu         off off"
# "maim                        maim                        take screenshot         arch ubuntu         off off"
)

programs_args=()
for index in "${!programs[@]}"; do
    program=${programs[$index]}
    package=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $1}')
    desc=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $3}')
    platforms=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $4}')
    IFS=' ' read -ra platforms_arr <<< "$platforms"
    selection=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $5}')
    selected=$(echo "$selection" | awk -F'[[:space:]]' -v preset="$preset" '{print $preset}')

    if [[ ${platforms_arr[*]} =~ $OS ]]; then
        programs_args+=("$index" "$package ($desc)" "$selected")
        ((index++))
    fi
done

selected_programs=$(dialog --title "Programs" --clear \
    --checklist "Choose programs to install:" 0 0 0 "${programs_args[@]}" \
    3>&1 1>&2 2>&3 3>&1)

# clone config repository
dialog --title "Config" --infobox "Cloning config repository.\n" 0 0

git clone https://github.com/bartol/config "$HOME"/.config/bartol &>/dev/null

# program custom install functions
zsh_install()
{
    install_all_platforms zsh
    echo "$password" | sudo -S chsh -s "$(command -v zsh)" "$USER"

    mkdir -p "$HOME"/.config/zsh
    ln -s "$HOME"/.config/bartol/zsh/.zprofile "$HOME"
    ln -s "$HOME"/.config/bartol/zsh/.zshrc "$HOME"/.config/zsh
    touch "$HOME"/.config/zsh/history
    mkdir -p "$HOME"/.config/zsh/plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$HOME"/.config/zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "$HOME"/.config/zsh/plugins/zsh-syntax-highlighting
}

alacritty_install()
{
    install_all_platforms alacritty

    mkdir -p "$HOME"/.config/alacritty
    ln -s "$HOME"/.config/bartol/alacritty/alacritty.yml "$HOME"/.config/alacritty
}

neovim_install()
{
    install_all_platforms neovim

    mkdir -p "$HOME"/.config/nvim
    ln -s "$HOME"/.config/bartol/nvim/init.vim "$HOME"/.config/nvim
    curl -fLo "$HOME"/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim -V0 -c "PlugInstall" -c ":qa" &>/dev/null
}

tmux_install()
{
    install_all_platforms tmux

    ln -s "$HOME"/.config/bartol/tmux/.tmux.conf "$HOME"
}

neomutt_install()
{
    install_all_platforms neomutt

    mkdir -p "$HOME"/.config/neomutt
    ln -s "$HOME"/.config/bartol/neomutt/neomuttrc "$HOME"/.config/neomutt
}

zathura_install()
{
    install_all_platforms zathura

    mkdir -p "$HOME"/.config/zathura
    ln -s "$HOME"/.config/bartol/zathura/zathurarc "$HOME"/.config/zathura
}

youtube_dl_install()
{
    install_all_platforms youtube-dl

    mkdir -p "$HOME"/.config/youtube-dl
    ln -s "$HOME"/.config/bartol/youtube-dl/config "$HOME"/.config/youtube-dl
}

ripgrep_install()
{
    install_all_platforms ripgrep

    mkdir -p "$HOME"/.config/ripgrep
    ln -s "$HOME"/.config/bartol/ripgrep/.ripgreprc "$HOME"/.config/ripgrep
}

bat_install()
{
    install_all_platforms bat

    mkdir -p "$HOME"/.config/bat
    ln -s "$HOME"/.config/bartol/bat/config "$HOME"/.config/bat
}

asciinema_install()
{
    install_all_platforms asciinema

    mkdir -p "$HOME"/.config/asciinema
    ln -s "$HOME"/.config/bartol/asciinema/config "$HOME"/.config/asciinema
}

bspwm_install()
{
    install_all_platforms bspwm

    mkdir -p "$HOME"/.config/bspwm
    ln -s "$HOME"/.config/bartol/bspwm/bspwmrc "$HOME"/.config/bspwm
}

sxhkd_install()
{
    install_all_platforms sxhkd

    mkdir -p "$HOME"/.config/sxhkd
    ln -s "$HOME"/.config/bartol/sxhkd/sxhkdrc "$HOME"/.config/sxhkd
}

polybar_install()
{
    install_all_platforms polybar

    mkdir -p "$HOME"/.config/polybar
    ln -s "$HOME"/.config/bartol/polybar/config "$HOME"/.config/polybar
}

# call program functions for all selected, not-installed programs
IFS=' ' read -ra selected_programs_arr <<< "$selected_programs"

for id in "${selected_programs_arr[@]}"
do
    program=${programs[id]}
    package=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $1}')
    bin=$(echo "$program" | awk -F'[[:space:]][[:space:]][[:space:]]*' '{print $2}')
    package_function_sufix="_install"

    if ! is_already_installed "$bin" --dialog
    then
        installing_message "$package"

        if function_exists "$package$package_function_sufix"
        then
            ("$package$package_function_sufix" &>/dev/null)
        else
            install_all_platforms "$package"
        fi

        is_install_successful "$bin" --dialog
    fi
done

clear

# exit message
echo
echo "  Script finished, thanks for using it!"
echo

if  [ -s "$HOME"/.config/bartol/successful_installs ]
then
    echo "  Successful installs:"
    awk '{ print "  - " $0 }' "$HOME"/.config/bartol/successful_installs
    echo
fi

if  [ -s "$HOME"/.config/bartol/failed_installs ]
then
    echo "  Failed installs:"
    awk '{ print "  - " $0 }' "$HOME"/.config/bartol/failed_installs
    echo
fi

if  [ -s "$HOME"/.config/bartol/already_installed ]
then
    echo "  Already installed:"
    awk '{ print "  - " $0 }' "$HOME"/.config/bartol/already_installed
    echo
fi

# end time counter
end_time=$(date +%s)

# elapsed time
elapsed_time=$((end_time - start_time))
if ((elapsed_time > 60))
then
    minutes=$((elapsed_time / 60))
    seconds=$((elapsed_time % 60))

    if ((minutes == 1))
    then
        minutes_text="minute"
    else
        minutes_text="minutes"
    fi
    if ((seconds == 1))
    then
        seconds_text="second"
    else
        seconds_text="seconds"
    fi

    echo "  Elapsed time: $minutes $minutes_text and $seconds $seconds_text"
else
    if ((elapsed_time == 1))
    then
        seconds_text="second"
    else
        seconds_text="seconds"
    fi

    echo "  Elapsed time: $elapsed_time $seconds_text"
fi
echo

# remove tmp
rm "$HOME"/.config/bartol/successful_installs
rm "$HOME"/.config/bartol/failed_installs
rm "$HOME"/.config/bartol/already_installed

exit 0
