#!/bin/bash

# This script will setup general settings when running Ubuntu in VMware vitrual machine.
#
# Github: https://github.com/zhwknight/setup-scripts

# Detect if in vmware
if (($(sudo dmidecode -s system-manufacturer | grep -ic VMware))); then
  # Install vm-tools
  sudo apt install -y open-vm-tools-desktop
  # Configure VMWare OpenGL support from 3.3 to 2.1 for gazebo and rviz
  vmware_graphics_acceleration_export="export SVGA_VGPU10=0"
  if grep -Fxq "$vmware_graphics_acceleration_export" ~/.profile; then
    :
  else
    echo "$vmware_graphics_acceleration_export" >>~/.profile
    eval $vmware_graphics_acceleration_export
  fi
fi