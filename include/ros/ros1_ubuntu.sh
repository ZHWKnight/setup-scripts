#!/bin/bash

# This script will install ROS1 in Ubuntu.
#
# Github: https://github.com/zhwknight/setup-scripts

cur_dir=$(cd -P "$(dirname "$0")" && pwd -P)
source $(dirname $cur_dir)/Public/general.sh

## Reference website:
# ROS (Robot Operating System) offical website
# https://www.ros.org/
# ROS Index
# https://index.ros.org/
# ROS Documentation
# https://index.ros.org/

if [[ ${DEVLOPMENT_MODE} == "false" ]]; then
  echo
  echo_colored "Deployment mode\n部署模式"

  ## This part of code is from website wiki.ros.org.
  ## http://wiki.ros.org/kinetic/Installation/Ubuntu
  ## http://wiki.ros.org/melodic/Installation/Ubuntu
  ## http://wiki.ros.org/noetic/Installation/Ubuntu

  # Setup sources and keys
  echo
  echo_colored "Setup sources and keys\n设定源和密钥" -FC blue
  echo
  sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 &&
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
  if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
    sudo apt install -y \
      ros-kinetic-desktop-full \
      python-rosdep \
      python-rosinstall \
      python-rosinstall-generator \
      python-wstool \
      python-catkin-tools \
      build-essential \
      ;
  elif [[ "${UBUNTU_RELEASE}" == "18.04" ]]; then
    sudo apt install -y \
      ros-melodic-desktop-full \
      python-rosdep \
      python-rosinstall \
      python-rosinstall-generator \
      python-wstool \
      python-catkin-tools \
      build-essential \
      ;
  elif [[ "${UBUNTU_RELEASE}" == "20.04" ]]; then
    sudo apt install -y \
      ros-noetic-desktop-full \
      python3-rosdep \
      python3-rosinstall \
      python3-rosinstall-generator \
      python3-wstool \
      python3-catkin-tools \
      python3-osrf-pycommon \
      build-essential \
      ;
  else
    echo_colored "ROS1 unsupport this OS, try again\nROS1 不支持此系统" -FC red
    exit 1
  fi
  if (($?)); then
    echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
    exit 1
  fi

  # Initialize rosdep
  echo
  echo_colored "Initialize rosdep\n初始化 rosdep" -FC blue
  echo

  if [[ -f "/etc/ros/rosdep/sources.list.d/20-default.list" ]]; then
    sudo rm "/etc/ros/rosdep/sources.list.d/20-default.list"
  fi

  if [[ ${PROXY_MODE} == "true" ]]; then PROXY_COMMAND="proxychains"; else PROXY_COMMAND=""; fi
  sudo ${PROXY_COMMAND} rosdep init &&
    ${PROXY_COMMAND} rosdep update

  if (($?)); then
    echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
    exit 1
  fi

  # Setup environment variables
  echo
  echo_colored "Setup environment variables\n设置环境变量" -FC blue

  if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
    rossource="source /opt/ros/kinetic/setup.bash"
    if grep -Fxq "$rossource" ~/.bashrc; then
      :
    else
      echo "$rossource" >>~/.bashrc
    fi
    eval $rossource
  else
    echo_colored "Do you want deploy dual version ROS?\n是否部署双版本 ROS?" -FC yellow
    read -p "[Y/n]" _INPUT
    case ${_INPUT} in
    [yY][eE][sS] | [yY])
      cp ros_selection.sh ${HOME}/.ros_selection.sh
      echo "alias ros=\"source ${HOME}/.ros_selection.sh\"" >>${HOME}/.bashrc
      source ${HOME}/.bashrc
      ros 1
      ;;
    [nN][oO] | [nN])
      if [[ "${UBUNTU_RELEASE}" == "18.04" ]]; then
        rossource="source /opt/ros/melodic/setup.bash"
        source /opt/ros/melodic/setup.bash
      elif [[ "${UBUNTU_RELEASE}" == "20.04" ]]; then
        rossource="source /opt/ros/noetic/setup.bash"
        source /opt/ros/noetic/setup.bash
      fi
      if grep -Fxq "$rossource" ~/.bashrc; then
        :
      else
        echo "$rossource" >>~/.bashrc
      fi
      eval $rossource
      ;;
    *)
      echo_colored "Invalid input, exiting now\n错误的输入，程序退出" -FC red
      exit 1
      ;;
    esac
  fi

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

  catkin_ws_source="source ${USER_ROS1_WORKSPACE}/devel/setup.bash"
  if grep -Fxq "$catkin_ws_source" ~/.bashrc; then
    :
  else
    echo "$catkin_ws_source" >>~/.bashrc
  fi
  eval $catkin_ws_source

  # Detect if in vmware
  echo
  echo_colored "Fix VMWare 3D graphics acceleration\n修复 VMWare 3D 显卡加速" -FC blue

  vmware_graphics_acceleration_export="export SVGA_VGPU10=0"
  if (($(sudo dmidecode -s system-manufacturer | grep -ic VMware))); then
    if grep -Fxq "$vmware_graphics_acceleration_export" ~/.profile; then
      :
    else
      echo "$vmware_graphics_acceleration_export" >>~/.profile
    fi
    eval $vmware_graphics_acceleration_export
  fi

elif [[ ${DEVLOPMENT_MODE} == "true" ]]; then
  echo
  echo_colored "Devlopment mode\n开发模式"
fi


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

echo_colored "$LAST_TIPS" -FC yellow
