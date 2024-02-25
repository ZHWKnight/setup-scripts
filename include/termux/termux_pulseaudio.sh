#!/data/data/com.termux/files/usr/bin/sh

# This script will setup virglrenderer(VirGL) on termux.
#
# Github: https://github.com/zhwknight/setup-scripts

# Update and upgrade termux
pkg update && pkg upgrade

pkg install -y pulseaudio
cat >> ~/.bashrc <<EOF
# PulseAudio
pulseaudio_start(){
  pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
  pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
}

EOF
. ~/.bashrc
