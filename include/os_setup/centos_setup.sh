#!/bin/bash

# This script will setup general settings when there is a new install of CentOS.
#
# Github: https://github.com/zhwknight/setup-scripts

# Set rpm source to TUNA
CENTOS_RELEASE=$(rpm -q centos-release | cut -d- -f3)
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

case $CENTOS_RELEASE in
"6")
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.tuna.tsinghua.edu.cn/repo/Centos-6.repo
  ;;
"7")
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.tuna.tsinghua.edu.cn/repo/Centos-7.repo
  ;;
"8")
  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.tuna.tsinghua.edu.cn/repo/Centos-8.repo
  ;;
*) ;;

esac
yum makecache
