#!/bin/bash

# This script will setup pip source to slove network problem.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set pip source to TUNA
mkdir ~/.pip
tee ~/.pip/pip.conf <<EOF >>/dev/null
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn/simple
EOF
sudo cp -r ~/.pip /root/
