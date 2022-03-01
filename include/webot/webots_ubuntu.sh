#!/bin/bash

# This script will install "Webots".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo wget -qO- https://cyberbotics.com/Cyberbotics.asc | sudo apt-key add -
sudo apt-add-repository 'deb https://cyberbotics.com/debian/ binary-amd64/'
sudo apt update
sudo apt-get install -y webots ros-melodic-webots-ros
echo "export WEBOTS_HOME=/usr/local/webots" >>~/.bashrc
