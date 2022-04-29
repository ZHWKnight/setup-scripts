#!/bin/bash

# This script will install "winehq".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo dpkg --add-architecture i386
pushd /tmp

wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo mv winehq.key /usr/share/keyrings/winehq-archive.key

sh_ubuntu_ver=$(lsb_release -cs)
wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/${sh_ubuntu_ver}/winehq-${sh_ubuntu_ver}.sources
sudo mv winehq-${sh_ubuntu_ver}.sources /etc/apt/sources.list.d/

wget -P /tmp https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/libfaudio0_19.07-0~bionic_i386.deb
wget -P /tmp https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/amd64/libfaudio0_19.07-0~bionic_amd64.deb
sudo apt install -y /tmp/libfaudio0_19.07-0~bionic_i386.deb /tmp/libfaudio0_19.07-0~bionic_amd64.deb
sudo apt update
sudo apt install -y --install-recommends winehq-stable winetricks

# https://wiki.winehq.org/Mono
# https://wiki.winehq.org/Gecko
mkdir ~/.cache/wine
wget -P ~/.cache/wine https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi
wget -P ~/.cache/wine https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi
wget -P ~/.cache/wine https://dl.winehq.org/wine/wine-mono/7.0.0/wine-mono-7.0.0-x86.msi

git clone https://gitee.com/ZHWKnight/gitstore_wine_winetricks.git
# tar -czvf - wine winetricks |split -b 95m - wine_winetricks.tar.gz
mkdir -p ~/.cache >/dev/null 2>&1
cat gitstore_wine_winetricks/wine_winetricks.tar.gza* | tar -xzvC ~/.cache


git clone https://gitee.com/ZHWKnight/gitstore_wine_windows_fonts.git
# tar -czvf - Fonts |split -b 95m - wine_windows_fonts.tar.gz
mkdir -p ~/.wine/drive_c/windows >/dev/null 2>&1
cat gitstore_wine_windows_fonts/wine_windows_fonts.tar.gza* | tar -xzvC ~/.wine/drive_c/windows

popd

winetricks riched20
winecfg
