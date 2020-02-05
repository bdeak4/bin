echo msmtp
mkdir -p ~/.config/msmtp
ln -s ~/config/mail/msmtp/config ~/.config/msmtp

echo neomutt
mkdir -p ~/.config/neomutt
ln -s ~/config/mail/neomutt/neomuttrc ~/.config/neomutt

echo isync
ln -s ~/config/mail/.mbsync ~
