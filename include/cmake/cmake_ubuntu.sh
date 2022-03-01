#!/bin/bash

# This script will install "cmake".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo apt-get update
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  gnupg \
  software-properties-common \
  wget \
  lsb-release \
  ;

wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

sudo apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -sc) main"
sudo apt-get update

sudo apt-get install -y kitware-archive-keyring
sudo rm /etc/apt/trusted.gpg.d/kitware.gpg
