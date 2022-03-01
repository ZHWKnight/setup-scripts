#!/bin/bash

# This script will install "winehq".
#
# Github: https://github.com/zhwknight/setup-scripts

sudo dpkg --add-architecture i386 
sudo wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main"
sudo cp ../../etc/apt/sources_lists/wineHQ_$(lsb_release -cs).list /etc/apt/sources.list.d/winehq.list
wget -P /tmp https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/libfaudio0_19.07-0~bionic_i386.deb
wget -P /tmp https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/amd64/libfaudio0_19.07-0~bionic_amd64.deb
sudo apt install -y /tmp/libfaudio0_19.07-0~bionic_i386.deb /tmp/libfaudio0_19.07-0~bionic_amd64.deb
sudo apt update
sudo apt install -y --install-recommends winehq-stable

# https://wiki.winehq.org/Mono
# https://wiki.winehq.org/Gecko
mkdir ~/.cache/wine
wget -P ~/.cache/wine https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi
wget -P ~/.cache/wine https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi
wget -P ~/.cache/wine https://dl.winehq.org/wine/wine-mono/5.1.1/wine-mono-5.1.1-x86.msi

sudo apt install -y winetricks
pushd /tmp
git clone https://gitee.com/ZHWKnight/gitstore_wine_winetricks.git
# tar -czvf - wine winetricks |split -b 95m - wine_winetricks.tar.gz
cat gitstore_wine_winetricks/wine_winetricks.tar.gza* | tar -xzvC ~/.cache

winetricks riched20

git clone https://gitee.com/ZHWKnight/gitstore_wine_windows_fonts.git
# tar -czvf - Fonts |split -b 95m - wine_windows_fonts.tar.gz
cat gitstore_wine_windows_fonts/wine_windows_fonts.tar.gza* | tar -xzvC ~/.wine/drive_c/windows
popd

winecfg