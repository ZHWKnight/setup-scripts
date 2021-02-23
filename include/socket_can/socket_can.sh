#!/bin/bash

# This script will setup "Socket CAN".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo modprobe can_dev
sudo modprobe can
sudo modprobe can_raw
sudo ip link set down can0
sudo ip link set can0 type can bitrate 500000
sudo ip link set up can0

# if using vcan to test
# modprobe vcan
# sudo ip link add dev vcan0 type vcan
# sudo ip link set up vcan0
