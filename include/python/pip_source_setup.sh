#!/bin/bash

# This script will setup pip source to slove network problem.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set pip source to aliyun
mkdir ~/.pip
tee ~/.pip/pip.conf <<-'EOF'
	[global]
	index-url = https://mirrors.aliyun.com/pypi/simple/
	[install]
	trusted-host = mirrors.aliyun.com
EOF
sudo cp -r ~/.pip /root/
