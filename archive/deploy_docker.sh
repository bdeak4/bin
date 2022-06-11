#!/bin/sh

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh
sudo apt install -y docker-compose
sudo usermod -aG docker $USER
# logout and log in
sudo systemctl start docker
sudo systemctl enable docker
git clone https://bdeak4:$PAT@github.com/bdeak4/chatter
cd chatter
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
git clone https://bdeak4:$PAT@github.com/bdeak4/juditadeak.com
sudo apt install nginx
# add nginx configs
sudo ln -s /etc/nginx/sites-available/chatter.bdeak.net /etc/nginx/sites-enabled/
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -n -m b@bdeak.net -d chatter.bdeak.net --redirect
