#!/data/data/com.termux/files/usr/bin/sh

# This script will setup virglrenderer(VirGL) on termux.
#
# Github: https://github.com/zhwknight/setup-scripts

# Update and upgrade termux
pkg update && pkg upgrade

pkg install x11-repo
pkg install termux-x11-nightly

cat >> ~/.bashrc <<EOF
# Termux X11
termux-x11_start(){
  export DISPLAY=:0
  termux-x11 :0
}

EOF
. ~/.bashrc
