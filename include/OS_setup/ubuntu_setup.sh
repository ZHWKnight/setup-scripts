#!/bin/bash

# This script will setup general settings when there is a new install of Ubuntu.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set apt source to aliyun
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo tee /etc/apt/sources.list <<EOF >>/dev/null
deb https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
# deb https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse
# deb https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse

# deb-src https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
EOF

sudo apt update

# Install language support
sudo apt install -y $(check-language-support)

sudo apt install -y \
  net-tools \
  vim \
  build-essential \
  git \
  curl \
  ;

# Set pip source to aliyun
source ../python/pip_source_setup.sh

mkdir ~/Worksp
