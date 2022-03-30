#!/bin/sh
#
# last update:	2022-05-22

set -ex

GOOD() { echo "\033[0;32m|> $1\033[0m"; }
BAD()  { echo "\033[0;31m|> $1\033[0m"; }

# presets
# *******

PRESETS=$(mktemp)
cat > $PRESETS << EOF
laptop	vim git
srv1	vim 
EOF
trap 'rm $PRESETS' EXIT

PRESET=$1
if [ -z "$PRESET" ]; then
	BAD "missing preset argument"
	exit 1
fi

if ! grep -q "^$PRESET	" $PRESETS; then
	BAD "preset not found"
	exit 2
fi

cd $HOME

# dependencies
# ************

REMOTE_BIN=https://raw.githubusercontent.com/bdeak4/bin/master

INSTALL() {
	for PROG in "$@"; do
		if ! [ -x "$(command -v $PROG)" ]; then
			GOOD "installing $PROG"
			sudo apt install -y $PROG
		else
			GOOD "$PROG already installed"
		fi
	done
}

GOOD "installing script dependencies"

sudo apt update
INSTALL git curl

PF=pf
if ! [ -x "$(command -v $PF)" ]; then
	PF=$(mktemp)
	curl -s "$REMOTE_BIN/pf" > "$PF"
	chmod +x "$PF"
	trap 'rm $PF' EXIT
fi

# auto-update
# ***********

GOOD "auto-updating script"

LOCAL_DATE=$(sed -n '3p' "$0" | cut -d'	' -f2)
REMOTE_DATE=$(curl -s "$REMOTE_BIN/setup.sh" | sed -n '3p' | cut -d'	' -f2)

if [ $(date -d "$REMOTE_DATE" +%s) -gt $(date -d "$LOCAL_DATE" +%s) ]; then
	cp "$0" "$0.$LOCAL_DATE"
	curl -s "$REMOTE_BIN/setup.sh" > "$0"
	BAD "script updated, please run it again"
	exit 2
fi

GOOD "script is up-to-date, continuing"

# common programs
# ***************

#...

for PROG in $(grep "^$PRESET	" $PRESETS | cut -d'	' -f2); do
	case $PROG in
		vim)
			INSTALL vim
			;;

		git)
			INSTALL git
			;;
	esac
done


exit





##############
# ....
###########

#
#
GOOD "installing common programs"

sudo apt install -y build-essential vim tmux wget jq tree rsync cron man

#
#
GOOD "patching common configuration files"

update_file .vimrc '"' << EOF
syn on
set ar cc=80 bg=dark
cmap w!! w !sudo tee % > /dev/null

au BufWritePost *.c  :sil !indent -linux %
au BufWritePost *.py :sil !black -ql 80 %
au BufWritePost *.ex,*.exs :sil !mix format %
au BufRead,BufNewFile *.py :setl ts=4 sw=4 et
au BufRead,BufNewFile *.ex,*.exs,*.heex,*.js :setl ts=2 sw=2 et
EOF

update_file .bashrcc '#' << EOF
file4
content2
EOF

#
#
GOOD "upgrading installed programs"

sudo apt upgrade -y

key=$(dd bs=1 count=1 2>/dev/null)

#
#

case "$PRESET" in
	desktop)
	;;

	server)
	;;

	vm)
	;;

	*)
	ERROR "unknown preset name"
	exit 1
	;;
esac

echo "$GREEN|> installing $device programs$NC" ################################

#install_node() {
#
#}
#
#install_elixir() {
#
#}

if [ "$device" = "desktop" ]; then
	sudo apt install -y \
		lxc htop ncdu \
		nmap mitmproxy \
		indent shellcheck universal-ctags \
		pdfgrep unzip pdfsandwich pandoc imagemagick \
		gimp vlc obs-studio \
		progress

	[ -z $SKIP_PYTHON ]	|| sudo apt install -y python3 python3-pip
	[ -z $SKIP_NODE ]	|| install_node
	[ -z $SKIP_ELIXIR ]	|| install_elixir
fi

if [ "$device" = "server" ]; then
	sudo apt install -y \
		lxc htop ncdu
fi

if [ "$device" = "vm" ]; then

	[ -z $SKIP_NODE ] || install_node
fi




#!!!!# install asdf version manager for python, elixir, node and dotnet

# get and import gpg key curl https://github.com/bdeak4.gpg
# add gpg to script deps
# download passwords
# check srv1.bdeak.net for more packages
# 6444  sudo apt install ./elixir_1.12.2-1~debian~buster_all.deb 
# 7373  sudo apt install ./MullvadVPN-2021.5_amd64.deb , vscode
# 8513  sudo apt install restic
# download node from nodesource
# add NODE_SKIP, PYTHON_SKIP=1, ELIXIR_SKIP flags
# yarn

# apt info mullvad-vpn 2>/dev/null | grep ^Version | cut -d' ' -f2
# curl -LIs https://mullvad.net/download/app/deb/latest | grep "^location.*\.deb.*" | sed -n 's/.*MullvadVPN-\(.*\)_.*/\1/p'


#sudo apt install -y \
#	sshfs \
#	mutt isync msmtp \
#	pass pass-extension-otp gpg remind \
#	



# vim download vim-elixir
# mutt, mailcap config
# mbsync config
# msmtp config
# libreoffice calc disable tools > autocorrect options > use replacement table

sudo apt autoremove -y

exit 0
