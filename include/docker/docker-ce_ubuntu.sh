#!/bin/bash

# This script will install "docker".
#
# Github: https://github.com/zhwknight/setup-scripts

# Remove old version
sudo apt remove -y \
  docker \
  docker-engine \
  docker.io \
  containerd \
  runc \
  ;

# Install packages to allow apt to use a repository over HTTPS
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  ;

# Add Docker’s official GPG key and set up the stable repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the apt package index
sudo apt update

# Install the latest version of Docker Engine - Community and containerd, or go to the next step to install a specific version
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  ;

# Adding your user to the "docker" group
sudo usermod -aG docker $USER
