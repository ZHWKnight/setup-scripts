#!/bin/bash

# This script will set multversion ros simultaneously.
#
# Github: https://github.com/zhwknight/setup-scripts

cur_dir=$(cd -P "$(dirname "$0")" && pwd -P)
. $(dirname $cur_dir)/Public/general.sh

## Reference website:
# ROS (Robot Operating System) offical website
# https://www.ros.org/
# ROS Index
# https://index.ros.org/
# ROS Documentation
# http://docs.ros.org/

# Setup environment variables
echo
echo_colored "Setup environment variables\n设置环境变量" -FC blue

echo_colored "Do you want deploy multversion ROS?\n是否部署多版本 ROS?" -FC yellow
read -p "[Y/n]" _INPUT
case ${_INPUT} in
[yY][eE][sS] | [yY])
  mkdir ${HOME}/.ros >/dev/null 2>&1
  cp ros_selection.sh ${HOME}/.ros/ros_selection.sh
  sed -ir ${HOME}/.bashrc \
    -e '/\/opt\/ros\/[a-z]*\/.*setup.bash/d' \
    -e '/\/home\/.*\/devel\/.*setup.bash/d' \
    -e '/\/home\/.*\/install\/.*setup.bash/d' \
    ;
  ros_selection="alias ros=\". ${HOME}/.ros/ros_selection.sh\""
  if grep -Fxq "$ros_selection" ~/.bashrc; then
    :
  else
    echo "$ros_selection" >>~/.bashrc
  fi
  ;;
[nN][oO] | [nN])
  echo_colored "Nothing to do, exiting now\n不进行修改，程序退出"
  exit 1
  ;;
*)
  echo_colored "Invalid input, exiting now\n错误的输入，程序退出" -FC red
  exit 1
  ;;
esac

echo
echo_colored "===============操作结束===============" -FC light_blue -DE bold
echo
