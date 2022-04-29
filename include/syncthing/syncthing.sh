#!/bin/bash

# This script will install "Syncthing".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" |
    sudo tee /etc/apt/sources.list.d/syncthing.list
# need proxy
sudo apt-get update
sudo apt-get install -y syncthing
