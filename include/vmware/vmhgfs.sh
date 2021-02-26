#!/bin/bash

# This script will setup vmhgfs share folders when running Ubuntu in VMware vitrual machine.
#
# Github: https://github.com/zhwknight/setup-scripts

mkdir -p $HOME/Shares
vmhgfs-fuse .host:/ $HOME/Shares -o subtype=vmhgfs-fuse,allow_other