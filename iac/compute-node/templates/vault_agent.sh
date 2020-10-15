#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl unzip ufw jq sshpass

sudo ufw allow 8200 # vault
sudo ufw allow 22
sudo ufw --force enable
sudo timedatectl set-timezone KST

# Vault Install - Host Key Signing 시 사용 목적으로 Host에 Vault를 
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault
