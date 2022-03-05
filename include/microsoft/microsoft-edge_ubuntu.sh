#!/bin/bash

# This script will install "Vusial Studio Code".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv BC528686B50D79E339D3721CEB3E94ADBE1229CF
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge/ stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y microsoft-edge-stable
