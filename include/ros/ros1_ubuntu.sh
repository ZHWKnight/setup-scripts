#!/bin/bash

# This script will install ROS-Kinetic in Ubuntu.
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

if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
  SH_ROS_DISTRO="kinetic"
  SH_ROS_PY="python"
elif [[ "${UBUNTU_RELEASE}" == "18.04" ]]; then
  SH_ROS_DISTRO="melodic"
  SH_ROS_PY="python"
elif [[ "${UBUNTU_RELEASE}" == "20.04" ]]; then
  SH_ROS_DISTRO="noetic"
  SH_ROS_PY="python3"
else
  echo_colored "ROS1 unsupport this OS, try again\nROS1 已停止或不能完全支持此系统" -FC red
  exit 1
fi

# Setup sources and keys
echo
echo_colored "Setup sources and keys\n设定源和密钥" -FC blue
echo
sudo apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 &&
  sudo sh -c '. /etc/lsb-release && echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
if (($?)); then
  echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
  exit 1
fi
sudo apt update

# Install ROS
echo
echo_colored "Install ROS1, build tools\n安装 ROS1 和构建工具" -FC blue
echo

sudo apt install -y \
  ros-${SH_ROS_DISTRO}-desktop-full \
  ${SH_ROS_PY}-rosdep \
  ${SH_ROS_PY}-rosinstall \
  ${SH_ROS_PY}-rosinstall-generator \
  ${SH_ROS_PY}-wstool \
  ${SH_ROS_PY}-catkin-tools \
  build-essential \
  ;
if (($?)); then
  echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
  exit 1
fi

# Setup environment variables
echo
echo_colored "Setup environment variables\n设置环境变量" -FC blue

ros_source=". /opt/ros/${SH_ROS_DISTRO}/setup.bash"
if grep -Fxq "$ros_source" ~/.bashrc; then
  :
else
  echo "$ros_source" >>~/.bashrc
fi
eval $ros_source

# Create ROS1 workspace
echo
echo_colored "Create ROS1 workspace\n新建 ROS1 工作空间" -FC blue
echo
mkdir -p ${USER_ROS1_WORKSPACE}/src
cd ${USER_ROS1_WORKSPACE}
catkin init
wstool init src
catkin build
if (($?)); then
  echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
  exit 1
fi

# Re-source environment to reflect new packages/build environment
echo
echo_colored "Re-source environment to reflect new packages/build environment\n重溯环境变量以刷新构建的软件包" -FC blue

catkin_ws_source=". ${USER_ROS1_WORKSPACE}/devel/setup.bash"
if grep -Fxq "$catkin_ws_source" ~/.bashrc; then
  :
else
  echo "$catkin_ws_source" >>~/.bashrc
fi
eval $catkin_ws_source

echo
echo_colored "===============操作结束===============" -FC light_blue -DE bold
echo

# Test ROS environment
roscore --help >/dev/null 2>&1
if (($?)); then
  echo_colored "ROS1 has NOT been installed correctly, try again.\nROS1 没有被正确安装，请重试" -FC red
else
  echo_colored "ROS1 has been installed correctly.\nROS1 已经被正确安装" -FC green
fi

echo_colored "${LAST_TIPS}" -FC yellow
