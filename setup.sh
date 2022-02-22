#!/bin/sh
#
# last update:	2022-02-22

set -ex

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# device
case $1 in
	-d|--desktop) device="desktop" ;;
	-s|--server) device="server" ;;
	*) echo "$RED|> missing device flag$NC"; exit 1 ;;
esac

# description:
# function updates file content without overwriting content that was in file
# before running the script. it can also handle multiple script runs with
# same or updated file contents
#
# how to use:
# updated_file <filename> <comment-delimiter> << EOF
# <file-content>
# EOF
update_file() {
	cat > /tmp/updated_content
	comment_start="$2 generated by setup.sh: start"
	comment_end="$2 generated by setup.sh: end"
	touch $1
	if grep -q "$comment_start" $1 && grep -q "$comment_end" $1; then
		head -n $(grep -n "$comment_start" $1 | cut -d: -f1) $1
		cat /tmp/updated_content
		tail -n +$(grep -n "$comment_end" $1 | cut -d: -f1) $1
	else
		cat $1
		echo
		echo $comment_start
		cat /tmp/updated_content
		echo $comment_end
	fi > /tmp/updated_file
	mv /tmp/updated_file $1
	rm /tmp/updated_content
}

echo "$GREEN|> installing script dependencies$NC" #############################

sudo apt update
sudo apt install -y git curl

echo "$GREEN|> auto-updating script$NC" #######################################

remote_url=https://raw.githubusercontent.com/bdeak4/bin/master/setup.sh
local_date=$(sed -n '3p' $0 | cut -d'	' -f2)
remote_date=$(curl -s "$remote_url" | sed -n '3p' | cut -d'	' -f2)

if [ $(date -d"$remote_date" +%s) -gt $(date -d"$local_date" +%s) ]; then
	cp $0 $0.$local_date
	curl -s "$remote_url" > $0
	echo "$RED|> script updated, please run it again$NC"
	exit 1
fi

echo "$GREEN|> script is up-to-date, continuing$NC"

echo "$GREEN|> installing common programs$NC" #################################

sudo apt update
sudo apt upgrade -y
sudo apt install -y \
	build-essential python3 python3-pip \
	git vim tmux curl wget tree rsync lxc cron man

echo "$GREEN|> patching common configuration files$NC" ########################

# git config
# vim config
# tmux config

update_file .vimrcc '"' << EOF
file5
content2
EOF

update_file .bashrcc '#' << EOF
file4
content2
EOF

echo "$GREEN|> installing $device programs$NC" ################################

if [ "$device" = "server" ]; then
	echo server
fi

if [ "$device" = "desktop" ]; then
	echo desktop
fi



# get and import gpg key curl https://github.com/bdeak4.gpg
# add gpg to script deps
# download passwords
# check srv1.bdeak.net for more packages
# 6444  sudo apt install ./elixir_1.12.2-1~debian~buster_all.deb 
# 7373  sudo apt install ./MullvadVPN-2021.5_amd64.deb 
# 8513  sudo apt install restic
# download node from nodesource



#sudo apt install -y \
#	indent shellcheck universal-ctags \
#	sshfs nmap mitmproxy \
#	mutt isync msmtp \
#	pass gpg remind \
#	pdfgrep pdfsandwich pandoc jq \
#	firefox imagemagick gimp vlc obs-studio htop



# vim download vim-elixir
# mutt, mailcap config
# mbsync config
# msmtp config

sudo apt autoremove -y

exit 0
