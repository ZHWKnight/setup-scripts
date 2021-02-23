#!/bin/bash

# This script will to do ROS version selection.
#
# Github: https://github.com/zhwknight/setup-scripts

# ROS 1.0 noetic or ROS 2.0 foxy
if [[ "$(lsb_release -rs)" == "18.04" ]]; then
  if [[ -d "/opt/ros/melodic" ]]; then
    FOUND_ROS1=melodic
  fi
  if [[ -d "/opt/ros/dashing" ]]; then
    FOUND_ROS2=dashing
  fi
elif [[ "$(lsb_release -rs)" == "20.04" ]]; then
  if [[ -d "/opt/ros/noetic" ]]; then
    FOUND_ROS1=noetic
  fi
  if [[ -d "/opt/ros/foxy" ]]; then
    FOUND_ROS2=foxy
  fi
fi

if [[ ${FOUND_ROS1:+"true"} == "true" && ${FOUND_ROS2:+"true"} != "true" ]]; then
  source /opt/ros/${FOUND_ROS1}/setup.bash
  source ${HOME}/Workspaces/ros1_ws/devel/setup.bash
elif [[ ${FOUND_ROS1:+"true"} != "true" && ${FOUND_ROS2:+"true"} == "true" ]]; then
  source /opt/ros/${FOUND_ROS2}/setup.bash

elif [[ ${FOUND_ROS1:+"true"} == "true" && ${FOUND_ROS2:+"true"} == "true" ]]; then

  if [[ $1 ]]; then
    _ROS_VERSION=$1
  else
    read -p "ROS 1 ${FOUND_ROS1} or ROS 2 ${FOUND_ROS2}? ...[1/2]" _ROS_VERSION
  fi
  if [[ ${_ROS_VERSION} == "1" ]]; then
    echo "Select ROS1 ${FOUND_ROS1}"
    source /opt/ros/${FOUND_ROS1}/setup.bash
    source ${HOME}/Workspaces/ros1_ws/devel/setup.bash
  elif [[ ${_ROS_VERSION} == "2" ]]; then
    echo "Select ROS2 ${FOUND_ROS2}"
    source /opt/ros/${FOUND_ROS2}/setup.bash
  else
    echo "Wrong input."
    exit 1
  fi
else
  echo "No ROS be found"
fi

# #source /home/ros/RobTool/ROS1/Wiki/devel/setup.bash
# #export ROS_MASTER_URI=http://192.168.1.100:11311
# #export ROS_IP=192.168.1.100
