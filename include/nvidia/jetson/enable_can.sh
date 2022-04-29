#!/bin/bash

sudo busybox devmem 0x0c303000 32 0x0000c400
sudo busybox devmem 0x0c303008 32 0x0000c458
sudo busybox devmem 0x0c303010 32 0x0000c400
sudo busybox devmem 0x0c303018 32 0x0000c458

sudo modprobe can
sudo modprobe can_raw
sudo modprobe can_dev
sudo modprobe mttcan

sudo ifconfig can0 down
sudo ifconfig can1 down

sudo ip link set can0 up type can bitrate 500000
sudo ip link set can1 up type can bitrate 500000

exit 0
