#!/bin/bash

# This script will to do ROS version selection.
#
# Github: https://github.com/zhwknight/setup-scripts

## Reference website:
# ROS (Robot Operating System) offical website
# https://www.ros.org/
# ROS Index
# https://index.ros.org/
# ROS Documentation
# http://docs.ros.org/

if [[ "$(lsb_release -rs)" == "18.04" ]]; then
  if [[ -d "/opt/ros/melodic" ]]; then
    FOUND_ROS_LIST[${#FOUND_ROS_LIST[@]}]=melodic
  fi
  if [[ -d "/opt/ros/dashing" ]]; then
    FOUND_ROS_LIST[${#FOUND_ROS_LIST[@]}]=dashing
  fi
elif [[ "$(lsb_release -rs)" == "20.04" ]]; then
  if [[ -d "/opt/ros/noetic" ]]; then
    FOUND_ROS_LIST[${#FOUND_ROS_LIST[@]}]=noetic
  fi
  if [[ -d "/opt/ros/foxy" ]]; then
    FOUND_ROS_LIST[${#FOUND_ROS_LIST[@]}]=foxy
  fi
  if [[ -d "/opt/ros/galactic" ]]; then
    FOUND_ROS_LIST[${#FOUND_ROS_LIST[@]}]=galactic
  fi
fi

if [[ $1 ]]; then
  _ros_version=$1
else
  echo "Found ROS version:"
  i=0
  for x in ${FOUND_ROS_LIST[@]}; do
    let i++
    # let i+=1
    # i=$((i+1))
    echo -e "$i,\t$x"
  done
  read -p "Which ROS version do you want? ... " _ros_version
fi
if [ ${_ros_version} -gt 0 ] && [ ${_ros_version} -le ${#FOUND_ROS_LIST[@]} ]; then
  echo "Select ROS ${FOUND_ROS_LIST[$((_ros_version - 1))]}"
  . /opt/ros/${FOUND_ROS_LIST[$((_ros_version - 1))]}/setup.bash
  alias ros1_local_ws=". ${HOME}/Worksp/ros1_ws/devel/local_setup.bash"
  alias ros2_local_ws=". ${HOME}/Worksp/ros2_ws/install/local_setup.bash"
else
  echo "Wrong input."
  exit 1
fi

#source /home/ros/RobTool/ROS1/Wiki/devel/setup.bash
#export ROS_MASTER_URI=http://192.168.1.100:11311
#export ROS_IP=192.168.1.100
