echo nvim
mkdir -p ~/.config/nvim
ln -s ~/config/editor/nvim/init.vim ~/.config/nvim
nvim +PlugInstall +q +q

echo vim
ln -s ~/config/editor/.vimrc ~
