#!/bin/bash

# This script will install "Aegisub - Advanced subtitle editor".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo add-apt-repository ppa:alex-p/aegisub
sudo apt-get update
sudo apt -y aegisub
