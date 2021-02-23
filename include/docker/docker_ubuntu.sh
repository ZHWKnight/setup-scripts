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
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  ;

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Use the following command to set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

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

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://1rxfvawf.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
