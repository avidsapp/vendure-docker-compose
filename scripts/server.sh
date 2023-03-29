#!/bin/bash

# format to use:
# ./server.sh

echo "Loading ENV VARS"
. ../.env

echo "Set Timezone"
sudo timedatectl set-timezone $TIMEZONE

echo "Installing Docker"
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Fixing Docker group settings"
sudo groupadd docker
sudo usermod -aG docker ${USER}

echo "Stopping Apache"
sudo service apache2 stop
sudo service nginx stop

echo "Installing Firewall"
sudo apt-get install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow http
sudo ufw allow https
sudo ufw enable

echo "Adding Fail2Ban"
sudo apt install fail2ban -y
sudo systemctl enable fail2ban

echo "Cloning repo"
git clone https://github.com/avidsapp/vendure-docker-compose.git

echo "Starting services"
cd vendure-docker-compose
docker-compose up -d

# REBOOT TO ACTIVATE CHANGES
sudo reboot
