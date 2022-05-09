#!/bin/bash

# This script will install "ZeroTier".
#
# Github: https://github.com/zhwknight/setup-scripts

# curl -s https://install.zerotier.com | sudo bash
# sudo apt install -y gpg
# curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import &&
#     if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi

sudo apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-key 74A5E9C458E1A431F1DA57A71657198823E52A61
sudo apt-add-repository "deb http://download.zerotier.com/debian/$(lsb_release -sc) $(lsb_release -sc) main"
sudo apt install -y zerotier-one
