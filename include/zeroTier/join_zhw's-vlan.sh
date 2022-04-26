#!/bin/bash

# This script will configure "ZeroTier".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo zerotier-cli join abfd31bd47528abd
sudo zerotier-cli listnetworks
sudo zerotier-cli orbit e683db72d1 e683db72d1
sudo zerotier-cli peers
