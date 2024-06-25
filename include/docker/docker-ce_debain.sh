#!/bin/bash

# This script will install "docker" at Ubuntu OS.
#
# Github: https://github.com/zhwknight/setup-scripts

# Remove old version
sudo apt remove -y \
  docker.io \
  docker-doc \
  docker-compose \
  podman-docker \
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
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /tmp/docker.asc
mv /tmp/docker.asc /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index
sudo apt update

# Install the latest version of Docker Engine - Community and containerd, or go to the next step to install a specific version
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  ;

# Adding your user to the "docker" group
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
