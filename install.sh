#!/bin/sh

# name                          description                     config directory                platform specific
required="$(cat <<EOF
curl                            http client                     n/a                             n/a
git                             version control                 ~                               n/a
brew                            package manager                 n/a                             macos
EOF
)"
programs="$(cat <<EOF
zsh                             shell                           ~/.config/zsh                   n/a
alacritty                       terminal emulator               ~/.config/alacritty             n/a
firefox-developer-edition       web browser                     ~/.mozilla/firefox              n/a
nvim                            text editor                     ~/.config/nvim                  n/a
nnn                             file manager                    ~/.config/nnn                   n/a
fzf                             fuzzy finder                    ~/.config/fzf                   n/a
neomutt                         email client                    ~/.config/neomutt               n/a
zathura                         pdf viewer                      ~/.config/zathura               n/a
fd                              better find                     n/a                             n/a
htop                            process viewer                  n/a                             n/a
bspwm                           tiling window manager           ~/.config/bspwm                 linux
sxhkd                           hotkey daemon                   ~/.config/sxhkd                 linux
polybar                         status bar                      ~/.config/polybar               linux
EOF
)"

# name                          type                            weights                         italics
fonts="$(cat <<EOF
Dank Mono                       monospace                       Regular                         yes
Proxima Nova                    sans-serif                      Regular,Light,Semibold,Bold     yes
EOF
)"

echo "$required"
echo "$programs"
echo "$fonts"
