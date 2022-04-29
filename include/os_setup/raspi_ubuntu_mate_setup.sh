#!/bin/bash

# This script will setup general settings when there is a new install of Ubuntu.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set apt source to TUNA
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak
sudo sed -i -e 's`http://raspbian.raspberrypi.org/raspbian/`http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/`' /etc/apt/sources.list
sudo sed -i -e 's`http://archive.raspberrypi.org/debian/`http://mirrors.tuna.tsinghua.edu.cn/raspberrypi/`' /etc/apt/sources.list.d/raspi.list

sudo apt update

sudo apt install -y \
	net-tools \
	vim \
	build-essential \
	git \
	curl \
	ubuntu-mate-desktop \
	;

# Install mate desktop environment
sudo apt install -y \
	ubuntu-mate-desktop \
	;

# Configure network from cloud-init to NetworkManager
sudo sh -c 'echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg'
sudo sh -c "cat <<EOF > /etc/netplan/01-network-manager-all.yaml
# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
EOF"

# Disable Wifi Powersaving to improve Pi WiFi performance
if [ -e /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf ]; then
  sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
fi

mkdir ~/Worksp

reboot
