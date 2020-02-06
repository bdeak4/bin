#!/usr/bin/env bash

# homebrew
if ! command -v brew >/dev/null; then
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

brew bundle -v --file="~/config/shell/Brewfile"

# fish
mkdir -p ~/.config/fish
ln -svi ~/config/shell/fish/config.fish ~/.config/fish

mkdir -p ~/.config/fish/functions
curl https://git.zx2c4.com/password-store/plain/src/completion/pass.fish-completion > ~/.config/fish/functions/pass.fish-completion

echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish

# git
mkdir -p ~/.config/git
ln -svi ~/config/shell/git/config ~/.config/git
ln -svi ~/config/shell/git/ignore ~/.config/git

# tmux
ln -svi ~/config/shell/.tmux.conf ~

# nvim
mkdir -p ~/.config/nvim
ln -svi ~/config/editor/nvim/init.vim ~/.config/nvim

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +q +q

# vim
ln -svi ~/config/editor/.vimrc ~

# fzf
"$(brew --prefix)"/opt/fzf/install

# alacritty
mkdir -p ~/.config/alacritty
ln -svi ~/config/gui/alacritty/alacritty.yml ~/.config/alacritty

# neomutt
mkdir -p ~/.config/neomutt
ln -svi ~/config/mail/neomutt/neomuttrc ~/.config/neomutt

# msmtp
mkdir -p ~/.config/msmtp
ln -svi ~/config/mail/msmtp/config ~/.config/msmtp

# isync
ln -svi ~/config/mail/.mbsync ~
