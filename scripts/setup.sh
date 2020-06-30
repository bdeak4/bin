#!/usr/bin/env bash

# dotfiles
DOTFILES=$HOME/dotfiles
git clone https://github.com/bartol/dotfiles $DOTFILES
ln -s $DOTFILES/.vimrc $HOME
ln -s $DOTFILES/.zshrc $HOME
ln -s $DOTFILES/.gitconfig $HOME
ln -s $DOTFILES/.editorconfig $HOME
ln -s $DOTFILES/.tmux.conf $HOME
ln -s $DOTFILES/.tmate.conf $HOME

# vim
mkdir -p $HOME/.vim/undo
git clone https://github.com/fatih/vim-go $HOME/.vim/pack/plugins/start/vim-go
git clone https://github.com/editorconfig/editorconfig-vim $HOME/.vim/pack/plugins/start/editorconfig-vim

# projects
PROJECTS=$HOME/dev
mkdir $PROJECTS
