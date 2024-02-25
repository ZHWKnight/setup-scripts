#!/data/data/com.termux/files/usr/bin/sh

# This script will setup general settings when there is a new install of termux.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set apt source to TUNA
termux-change-repo
# Update and upgrade termux
pkg update && pkg upgrade -y
pkg autoclean

## Set up storage, so we can access the storage of the phone
## the storage will be mounted at ~/storage
termux-setup-storage

## open ssh server
pkg install -y openssh
## start ssh server, notice that default port of termux is 8022
## for one time
sshd
## for always
# echo "sshd" > ~/.profile
## you can add public key to ~/.ssh/authorized_keys to enable passwordless login
# echo <public-key> > ~/.ssh/authorized_keys


## $PREFIX/etc/motd​ saved the message of the welcome screen, can be modified to show some useful info
# echo "Welcome ZHWKnight to Termux!" > $PREFIX/etc/motd

## Android version upper then 12, system enable Phantom Process Killing by default, we need to disable it.
## if not, when child process nunber > 32, when kill the main process, display info like:
## [Process completed (signal 9) - press Enter]
#
## for Android 14 and upper
# Settings-> Developer Options -> Disable child process restrictions
## for other version
# pkg install andriod-tools
# adb pair <address>:<port>
# adb connect <address>:<port>
# adb devices
## then enter the pairing code 
#
## for Android 12L and Android 13
# ./adb shell "settings put global settings_enable_monitor_phantom_procs false"
## for Android 12 without GMS
# ./adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
## for Android 12 with GMS
# ./adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
# ./adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647" 

