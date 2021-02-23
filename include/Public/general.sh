#!/bin/bash

# General script library.
# 通用脚本库

# Script genaral options.
# 脚本通用选项和变量
PRIVILEGE_MODE="false"
DEVLOPMENT_MODE="false"
PROXY_MODE="false"
PROXY_COMMAND=""
set -o pipefail
CPUCORES=$(cat /proc/cpuinfo | grep "processor" | wc -l)
TEMPLET_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SCRIPT_DIR=${TEMPLET_DIR%/*}
USER_APP_DIR=${HOME}/App
USER_ENV_DIR=${HOME}/Env
USER_PKG_DIR=${HOME}/Downloads/Pkg
USER_ROS1_WORKSPACE=${HOME}/Workspaces/ros1_ws
USER_ROS2_WORKSPACE=${HOME}/Workspaces/ros2_ws

UBUNTU_RELEASE=$(lsb_release -rs)
LAST_TIPS=""

echo_colored() {
  local arg
  local arg_index=0

  local foreground_color_param
  local background_color_param
  local decoration_param

  for arg in "$@"; do
    if [[ $arg == "-FC" ]]; then eval local foreground_color_index=$(echo \$"$(expr $arg_index + 2)"); fi
    if [[ $arg == "-BC" ]]; then eval local background_color_index=$(echo \$"$(expr $arg_index + 2)"); fi
    if [[ $arg == "-DE" ]]; then eval local decoration_index=$(echo \$"$(expr $arg_index + 2)"); fi
    if [[ $arg == "-NN" ]]; then local no_newline_flag="true"; fi
    if [[ $arg == "-NR" ]]; then local no_reset_flag="true"; fi
    let arg_index+=1
  done

  case $foreground_color_index in
  "default")
    foreground_color_param="39"
    ;;
  "black")
    foreground_color_param="30"
    ;;
  "red")
    foreground_color_param="31"
    ;;
  "green")
    foreground_color_param="32"
    ;;
  "yellow")
    foreground_color_param="33"
    ;;
  "blue")
    foreground_color_param="34"
    ;;
  "magenta")
    foreground_color_param="35"
    ;;
  "cyan")
    foreground_color_param="36"
    ;;
  "light_gray")
    foreground_color_param="37"
    ;;
  "dark_gray")
    foreground_color_param="90"
    ;;
  "light_red")
    foreground_color_param="91"
    ;;
  "light_green")
    foreground_color_param="92"
    ;;
  "light_yellow")
    foreground_color_param="93"
    ;;
  "light_blue")
    foreground_color_param="94"
    ;;
  "light_purple")
    foreground_color_param="95"
    ;;
  "light_azure")
    foreground_color_param="96"
    ;;
  "white")
    foreground_color_param="97"
    ;;
  *)
    foreground_color_param="39"
    ;;
  esac

  case $background_color_index in
  "default")
    background_color_param="49"
    ;;
  "black")
    background_color_param="40"
    ;;
  "red")
    background_color_param="41"
    ;;
  "green")
    background_color_param="42"
    ;;
  "yellow")
    background_color_param="43"
    ;;
  "blue")
    background_color_param="44"
    ;;
  "magenta")
    background_color_param="45"
    ;;
  "cyan")
    background_color_param="46"
    ;;
  "light_gray")
    background_color_param="47"
    ;;
  "dark_gray")
    background_color_param="100"
    ;;
  "light_red")
    background_color_param="101"
    ;;
  "light_green")
    background_color_param="102"
    ;;
  "light_yellow")
    background_color_param="103"
    ;;
  "light_blue")
    background_color_param="104"
    ;;
  "light_purple")
    background_color_param="105"
    ;;
  "light_azure")
    background_color_param="106"
    ;;
  "white")
    background_color_param="107"
    ;;
  *)
    background_color_param="49"
    ;;
  esac

  case $decoration_index in
  "reset_all")
    decoration_param="0"
    ;;
  "bold")
    decoration_param="1"
    ;;
  "dim")
    decoration_param="2"
    ;;
  "italic")
    decoration_param="3"
    ;;
  "underline")
    decoration_param="4"
    ;;
  "blink")
    decoration_param="5"
    ;;
  "reverse")
    decoration_param="7"
    ;;
  "hidden")
    decoration_param="8"
    ;;
  "deleted")
    decoration_param="9"
    ;;
  "reset_bold")
    decoration_param="21"
    ;;
  "reset_dim")
    decoration_param="22"
    ;;
  "reset_italic")
    decoration_param="23"
    ;;
  "reset_underline")
    decoration_param="24"
    ;;
  "reset_blink")
    decoration_param="25"
    ;;
  "reset_reverse")
    decoration_param="27"
    ;;
  "reset_hidden")
    decoration_param="28"
    ;;
  "reset_deleted")
    decoration_param="29"
    ;;
  *)
    decoration_param="0"
    ;;
  esac

  local reset_param
  local newline_param

  if [[ $no_newline_flag == "true" ]]; then
    newline_param="n"
  else
    newline_param=""
  fi

  if [[ $no_reset_flag == "true" ]]; then
    reset_param=""
  else
    reset_param="\e[0m"
  fi

  echo -e${newline_param} "\e[${decoration_param:-0};${foreground_color_param:-39};${background_color_param:-49}m$1${reset_param}"
}

countdown() {
  echo
  local count=$1
  local i
  for i in $(seq -w $count -1 0); do
    echo -en "Start after \e[33m$i\e[0m seconds | 将在 \e[33m$i\e[0m 秒后继续...\r"
    sleep 1
  done
}

check_exist() {
  local _DEST_DIR=$1
  local _DEST_PREFIX=$2
  local _DEST_FILE=$3
  local _FILES=$(
    shopt -s nullglob dotglob
    echo ${_DEST_DIR}/${_DEST_PREFIX}/${_DEST_FILE}*
  )
  # echo ${_FILES}
  if [ ${#_FILES} != 0 ]; then
    echo_colored "${_DEST_DIR}/${_DEST_PREFIX}/${_DEST_FILE}\nFile already exists\n文件已经存在"
    return 0
  else
    echo_colored "${_DEST_DIR}/${_DEST_PREFIX}/${_DEST_FILE}\nFile is not found\n文件未找到"
    return 1
  fi
}

check_app_exist() {
  if check_exist ${HOME}/App $1 $2; then
    return 0
  else
    return 1
  fi
}

check_env_exist() {
  if check_exist ${HOME}/Env $1 $2; then
    return 0
  else
    return 1
  fi
}

check_pkg_exist() {
  if check_exist ${HOME}/Downloads/Pkg $1 $2; then
    return 0
  else
    return 1
  fi
}

download_pkg() {
  local _PKG_NAME=$1
  local _PKG_PREFIX=$2
  local _PKG_FILE=$3
  local _PKG_DOWNLOAD_URL=$4
  check_pkg_exist ${_PKG_PREFIX} ${_PKG_FILE}
  if (($?)); then
    echo_colored "Downloading \"${_PKG_NAME}\"\n开始下载 \"${_PKG_NAME}\""
    mkdir -p ${USER_PKG_DIR}/${_PKG_PREFIX}
    if [[ ${PROXY_MODE} == "true" ]]; then PROXY_COMMAND="proxychains"; else PROXY_COMMAND=""; fi
    ${PROXY_COMMAND} wget ${_PKG_DOWNLOAD_URL} -O ${USER_PKG_DIR}/${_PKG_PREFIX}/${_PKG_FILE}
    if (($?)); then
      echo_colored "Error downloading \"${_PKG_NAME}\"\n下载 \"${_PKG_NAME}\" 时发生错误" -FC red
      rm -rf ${USER_PKG_DIR}/${_PKG_PREFIX}
      return 1
    else
      echo_colored "Download \"${_PKG_NAME}\" complete\n下载 \"${_PKG_NAME}\" 完成"
      return 0
    fi
  else
    echo_colored "No need download\n无需下载"
    return 0
  fi
}

echo
echo_colored "Initialize scrpit execution environment\n初始化脚本运行环境" -FC blue

# Read Script execution argument.
# 读取脚本执行参数
for arg in "$@"; do
  if [[ $arg == "--dev_mode" ]]; then DEVLOPMENT_MODE="true"; fi
  if [[ $arg == "--proxy_mode" ]]; then PROXY_MODE="true"; fi
done

# Check shell runner, it must be right authority.
# 检查脚本执行权限，必须以正确权限执行
echo
echo_colored "Check scrpit execution authority\n检查脚本运行权限"
echo

if [[ $(whoami) == "root" ]]; then
  _PRIVILEGE_MODE=true
  echo "Run as root."
else
  _PRIVILEGE_MODE="false"
  echo "Run as user."
fi
if [[ ${PRIVILEGE_MODE} == ${_PRIVILEGE_MODE} ]]; then
  echo_colored "Execution authority was correct\n运行权限正确" -FC green
else
  echo_colored "Execution authority was incorrect\n运行权限错误" -FC red
  exit 1
fi

# Check Ubuntu version.
# 检查 Ubuntu 系统版本
echo
echo_colored "Check Ubuntu version\n检查 Ubuntu 系统版本"
echo

if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
  echo "OS version detected as $(lsb_release -sc) $(lsb_release -rs)"
  echo_colored "OS version was supported\n支持的系统版本" -FC green
elif [[ "${UBUNTU_RELEASE}" == "18.04" ]]; then
  echo "OS version detected as $(lsb_release -sc) $(lsb_release -rs)"
  echo_colored "OS version was supported\n支持的系统版本" -FC green
elif [[ "${UBUNTU_RELEASE}" == "20.04" ]]; then
  echo "OS version detected as $(lsb_release -sc) $(lsb_release -rs)"
  echo_colored "OS version was supported\n支持的系统版本" -FC green
else
  echo "OS version detected as $(lsb_release -sc) $(lsb_release -rs)"
  echo_colored "OS version was unsupported\n不支持的系统版本" -FC red
  exit 1
fi

# Check proxychains status.
# 检查 proxychains 代理状态
if [[ ${PROXY_MODE} == "true" ]]; then
  echo
  echo_colored "Proxy mode\n代理模式"
  echo
  echo_colored "Check proxychains status\n检查 proxychains 状态"
  echo
  if [ -x /usr/bin/proxychains ]; then
    echo_colored "proxychains has been installed\nproxychains 已经安装" -FC green
  else
    echo_colored "proxychains has NOT been installed\nproxychains 未安装" -FC red
    echo_colored "Do you want install now?\n是否现在安装?" -FC yellow
    read -p "[Y/n]" _INPUT
    case ${_INPUT} in
    [yY][eE][sS] | [yY])
      sudo apt update
      if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
        sudo apt install proxychains -y
      else
        sudo apt install proxychains4 -y
      fi
      if [[ $? != 0 ]]; then
        echo_colored "Install failed, check internet status and try again\n安装失败，请检查网络状态后重试" -FC red
        exit 1
      fi
      ;;
    [nN][oO] | [nN])
      echo_colored "No, close proxy mode\n否，关闭代理模式"
      PROXY_MODE="false"
      ;;
    *)
      echo_colored "Invalid input, exiting now\n错误的输入，程序退出"
      exit 1
      ;;
    esac
  fi
  if [[ ${PROXY_MODE} == "true" ]]; then
    proxychains curl www.baidu.com >/dev/null 2>&1
    if ((!$?)); then
      echo_colored "proxychains has been configured correctly\nproxychains 已经正确配置" -FC green
    else
      echo_colored "proxychains has NOT been configured correctly, configure it and try again\nproxychains 未正确配置，请配置后重试" -FC red
      echo_colored "close proxy mode\n关闭代理模式"
      PROXY_MODE="false"
    fi
  fi
fi
