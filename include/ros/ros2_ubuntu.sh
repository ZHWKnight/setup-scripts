#!/bin/bash

# This script will install ROS2 in Ubuntu.
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

if [[ "${UBUNTU_RELEASE}" == "18.04" ]]; then
  SH_ROS_DISTRO="dashing"
elif [[ "${UBUNTU_RELEASE}" == "20.04" ]]; then
  SH_ROS_DISTRO="galactic"
else
  echo_colored "ROS2 unsupport this OS, try again\nROS2 已停止或不能完全支持此系统" -FC red
  exit 1
fi

# Setup sources and keys
echo
echo_colored "Setup sources and keys\n设定源和密钥" -FC blue
echo
sudo apt update
sudo apt install -y \
  curl \
  gnupg2 \
  lsb-release \
  ;

${PROXY_COMMAND} curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
if (($?)); then
  echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
  exit 1
fi
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
sudo apt update

# Install ROS
echo
echo_colored "Install ROS2, build tools\n安装 ROS2 和构建工具" -FC blue
echo

sudo apt install -y \
  ros-${SH_ROS_DISTRO}-desktop \
  ros-${SH_ROS_DISTRO}-ros1-bridge \
  python3-colcon-common-extensions \
  python3-argcomplete \
  python3-vcstool \
  ;

if (($?)); then
  echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
  exit 1
fi

# Setup environment variables
echo
echo_colored "Setup environment variables\n设置环境变量" -FC blue

rossource=". /opt/ros/${SH_ROS_DISTRO}/setup.bash"
if grep -Fxq "$ros_source" ~/.bashrc; then
  :
else
  echo "$ros_source" >>~/.bashrc
fi
eval $ros_source

# Create ROS2 workspace
echo
echo_colored "Create ROS2 workspace\n新建 ROS2 工作空间" -FC blue
echo
mkdir -p ${USER_ROS2_WORKSPACE}/src
cd ${USER_ROS2_WORKSPACE}
colcon build
if (($?)); then
  echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
  exit 1
fi

# Re-source environment to reflect new packages/build environment
echo
echo_colored "Re-source environment to reflect new packages/build environment\n重溯环境变量以刷新构建的软件包" -FC blue

catkin_ws_source=". ${USER_ROS1_WORKSPACE}/install/local_setup.bash"
if grep -Fxq "$catkin_ws_source" ~/.bashrc; then
  :
else
  echo "$catkin_ws_source" >>~/.bashrc
fi
eval $catkin_ws_source

# Test ROS environment
echo
echo_colored "===============操作结束===============" -FC light_blue -DE bold
echo

ros2 --help >/dev/null 2>&1
if (($?)); then
  echo_colored "ROS2 has NOT been installed correctly, try again.\nROS2 没有被正确安装，请重试" -FC red
else
  echo_colored "ROS2 has been installed correctly.\nROS2 已经被正确安装" -FC green
fi

echo_colored "$LAST_TIPS" -FC yellow
