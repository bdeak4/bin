#!/bin/bash

# install homebrew
if ! command -v brew >/dev/null
then
    case $OSTYPE in
        "darwin"*)
            xcode-select --install
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            ;;
        "linux-gnu")
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
            test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
            echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
            ;;
        *) echo "OS not supported."; exit 1;;
    esac
fi

# install programs
brew bundle -v --file="~/config/shell/Brewfile"

# link configs
for file in */link.sh
do
    bash "$file"
done
