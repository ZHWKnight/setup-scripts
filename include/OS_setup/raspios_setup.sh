#!/bin/bash

# This script will setup general settings when there is a new install of RaspiOS.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set apt source to aliyun
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.list.bak
sudo sed -i -e 's`http://raspbian.raspberrypi.org/raspbian/`https://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/`' /etc/apt/sources.list
sudo sed -i -e 's`http://archive.raspberrypi.org/debian/`https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/`' /etc/apt/sources.list.d/raspi.list

sudo apt update

sudo apt install -y \
  net-tools \
  vim \
  build-essential \
  git \
  curl \
  ;

mkdir ~/Workspaces
