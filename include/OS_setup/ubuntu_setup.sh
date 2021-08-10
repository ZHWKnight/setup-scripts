#!/bin/bash

# This script will setup general settings when there is a new install of Ubuntu.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set apt source to aliyun
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo cp ../../etc/apt/sources_lists/$(lsb_release -is)_$(lsb_release -cs).list /etc/apt/sources.list

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

mkdir ~/Workspaces
