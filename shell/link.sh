echo fish
mkdir -p ~/.config/fish
ln -s ~/config/shell/fish/config.fish ~/.config/fish
ln -s ~/config/shell/fish/functions ~/.config/fish

echo git
mkdir -p ~/.config/git
ln -s ~/config/shell/git/config ~/.config/git
ln -s ~/config/shell/git/ignore ~/.config/git

echo tmux
ln -s ~/config/shell/.tmux.conf ~
