#!/bin/bash

# This script will install ROS2 in Ubuntu.
#
# Github: https://github.com/zhwknight/setup-scripts

cur_dir=$(cd -P "$(dirname "$0")" && pwd -P)
source $(dirname $cur_dir)/Public/general.sh

## Reference website:
# ROS (Robot Operating System) offical website
# https://www.ros.org/
# ROS Index
# https://index.ros.org/
# ROS2 Documentation
# https://index.ros.org/doc/ros2/

if [[ "${UBUNTU_RELEASE}" == "18.04" ]]; then
  SH_ROS_DISTRO="dashing"
elif [[ "${UBUNTU_RELEASE}" == "20.04" ]]; then
  SH_ROS_DISTRO="foxy"
else
  echo_colored "ROS2 unsupport this OS, try again\nROS1 不支持此系统" -FC red
  exit 1
fi

if [[ ${DEVLOPMENT_MODE} == "false" ]]; then
  echo
  echo_colored "Deployment mode\n部署模式"

  ## This part of code is from website wiki.ros.org.
  ## https://index.ros.org/doc/ros2/Installation/Dashing/
  ## https://index.ros.org/doc/ros2/Installation/Foxy/

  # Setup sources and keys
  echo
  echo_colored "Setup sources and keys\n设定源和密钥"
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
  echo_colored "Install ROS2, build tools\n安装 ROS2 和构建工具"
  echo

  sudo apt install -y \
    ros-${SH_ROS_DISTRO}-desktop \
    ros-${SH_ROS_DISTRO}-ros1-bridge \
    python3-colcon-common-extensions \
    python3-argcomplete \
    ;

  if (($?)); then
    echo_colored "Error occurred, try again\n发生错误，请重试" -FC red
    exit 1
  fi

  # Setup environment variables
  echo
  echo_colored "Setup environment variables\n设置环境变量"

  echo_colored "Do you want deploy dual version ROS?\n是否部署双版本 ROS?" -FC yellow
  read -p "[Y/n]" _INPUT
  case ${_INPUT} in
  [yY][eE][sS] | [yY])
    cp ros_selection.sh ${HOME}/.ros_selection.sh
    rosselect="alias ros=\". ${HOME}/.ros_selection.sh\""
    if grep -Fxq "$rosselect" ~/.bashrc; then
      :
    else
      echo "$rosselect" >>~/.bashrc
    fi
    source /opt/ros/${SH_ROS_DISTRO}/setup.bash
    ;;
  [nN][oO] | [nN])
    rossource="source /opt/ros/${SH_ROS_DISTRO}/setup.bash"
    if grep -Fxq "$rossource" ~/.bashrc; then
      :
    else
      echo "$rossource" >>~/.bashrc
    fi
    eval $rossource
    ;;
  *)
    echo_colored "Invalid input, exiting now\n错误的输入，程序退出"
    exit 1
    ;;
  esac

  # Create ROS2 workspace
  echo
  echo_colored "Create ROS2 workspace\n新建 ROS2 工作空间"
  echo
  mkdir -p ${USER_ROS2_WORKSPACE}/src
  cd ${USER_ROS2_WORKSPACE}
  colcon build
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

  sudo ${PROXY_COMMAND} rosdep init &&
    ${PROXY_COMMAND} rosdep update

  if (($?)); then
    echo_colored "Error occurred, try again\n发生错误，请稍后重试，这一步通常因为网络问题导致失败！" -FC red
    # exit 1
  fi

elif [[ ${DEVLOPMENT_MODE} == "true" ]]; then
  echo
  echo_colored "Devlopment mode\n开发模式"

fi

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
