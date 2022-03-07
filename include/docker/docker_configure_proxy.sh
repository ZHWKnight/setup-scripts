#!/bin/bash

# This script will set docker-registry-mirrors to localization.
#
# Github: https://github.com/zhwknight/setup-scripts
# 

## regular install
# sudo mkdir -p /etc/docker
## rootless mode
# mkdir -p ~/.docker

sudo tee /etc/docker/config.json <<EOF >>/dev/null
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "socks5://127.0.0.1:51080",
     "httpsProxy": "socks5://127.0.0.1:51080",
     "noProxy": "NO_PROXY=localhost,127.0.0.1,aliyuncs.com,docker-registry.example.com,.example.com,,example.com"
   }
 }
}
EOF
# Then create or start new containers, the environment variables are set automatically within the container.
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl show --property=Environment docker


## Use environment variables
# Set the environment variables manually
# docker run example
# --env HTTP_PROXY="socks5://127.0.0.1:51080"
# --env HTTPS_PROXY="socks5://127.0.0.1:51080"
# --env FTP_PROXY="ftp://192.168.1.12:3128"
# --env NO_PROXY="localhost,127.0.0.1,aliyuncs.com,docker-registry.example.com,.example.com,,example.com"

# Use systemd 
## regular install
# sudo mkdir -p /etc/systemd/system/docker.service.d
## rootless mode
# mkdir -p ~/.config/systemd/user/docker.service.d

# sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF >>/dev/null
# # Environment="HTTP_PROXY=socks5://127.0.0.1:51080"
# # Environment="HTTPS_PROXY=socks5://127.0.0.1:51080"
# # Environment="NO_PROXY=localhost,127.0.0.1,aliyuncs.com,docker-registry.example.com,.example.com,,example.com"
# EOF
# sudo systemctl daemon-reload
# sudo systemctl restart docker
# sudo systemctl show --property=Environment docker
