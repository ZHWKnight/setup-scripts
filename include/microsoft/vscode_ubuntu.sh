#!/bin/bash

# This script will install "Vusial Studio Code".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key BC528686B50D79E339D3721CEB3E94ADBE1229CF
sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

sudo sh -c 'echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf'
sudo sysctl -p
