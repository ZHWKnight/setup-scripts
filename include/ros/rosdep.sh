#!/bin/bash

# This script will initialize and update the rosdep cache.
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

# Initialize rosdep
echo
echo_colored "Initialize rosdep\n初始化 rosdep" -FC blue
echo

if [[ -f "/etc/ros/rosdep/sources.list.d/20-default.list" ]]; then
  sudo rm "/etc/ros/rosdep/sources.list.d/20-default.list"
fi

sudo ${PROXY_COMMAND} rosdep init &&
  ${PROXY_COMMAND} rosdep update

if (($?)); then
  echo_colored "Error occurred, try again\n发生错误，请稍后重试，这一步通常因为网络问题导致失败！" -FC red
  # exit 1
fi

echo
echo_colored "===============操作结束===============" -FC light_blue -DE bold
echo
