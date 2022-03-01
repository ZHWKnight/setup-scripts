#!/bin/bash

# This script will install "chrome".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key EB4C1BFD4F042F6DDDCCEC917721F63BD38B4796
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
sudo apt update
sudo apt install -y google-chrome-stable
