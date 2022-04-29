#!/bin/bash

# This script will install gcc and g++ in Ubuntu.
#
# Github: https://github.com/zhwknight/setup-scripts

# sudo apt install software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test

sudo apt install -y \
  gcc-7 \
  g++-7 \
  gcc-8 \
  g++-8 \
  gcc-9 \
  g++-9 \
  gcc-10 \
  g++-10 \
  gcc-11 \
  g++-11 \
  ;

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 90 --slave /usr/bin/g++ g++ /usr/bin/g++-11 --slave /usr/bin/gcov gcov /usr/bin/gcov-11
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 90 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9 --slave /usr/bin/gcov gcov /usr/bin/gcov-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80 --slave /usr/bin/g++ g++ /usr/bin/g++-8 --slave /usr/bin/gcov gcov /usr/bin/gcov-8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gcov gcov /usr/bin/gcov-7

sudo update-alternatives --config gcc
