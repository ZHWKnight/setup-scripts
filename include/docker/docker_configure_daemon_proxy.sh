#!/bin/bash

# This script will set docker-registry-mirrors to localization.
#
# Github: https://github.com/zhwknight/setup-scripts
# 

# Use systemd 
## regular install
sudo mkdir -p /etc/systemd/system/docker.service.d
## rootless mode
# mkdir -p ~/.config/systemd/user/docker.service.d

sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >>/dev/null
# Environment="HTTP_PROXY=http://192.168.192.200:57890"
# Environment="HTTPS_PROXY=http://192.168.192.200:57890"
# Environment="NO_PROXY=localhost,127.0.0.1"
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl show --property=Environment docker
