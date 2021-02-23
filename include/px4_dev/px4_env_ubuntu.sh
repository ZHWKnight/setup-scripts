#!/bin/bash

# This script will setup PX4 develop environment in Ubuntu.
#
# Github: https://github.com/zhwknight/setup-scripts

cur_dir=$(cd -P "$(dirname "$0")" && pwd -P)
source $(dirname $cur_dir)/Public/general.sh

## Reference website:
# PX4 Autopilot User Guide (master)
# https://docs.px4.io/master/en/index.html
# PX4 Development Guide (master)
# https://dev.px4.io/master/en/index.html

# Read Script execution argument.
for arg in "$@"; do
  if [[ $arg == "--no_nuttx" ]]; then INSTALL_NUTTX="false"; fi
  if [[ $arg == "--no_qgc" ]]; then INSTALL_QGC="false"; fi
  if [[ $arg == "--sim" ]]; then INSTALL_SIM="true"; fi
done

if [[ ${DEVLOPMENT_MODE} == "false" ]]; then

  echo
  echo_colored "Deployment mode\n部署模式"

  ## Reference website:
  # This part of code is from ubuntu.sh at github.
  # https://raw.githubusercontent.com/PX4/Firmware/v1.10.1/Tools/setup/ubuntu.sh

  if [ -f /.dockerenv ]; then
    echo_colored "Running within docker, installing initial dependencies\n运行在 docker 内部，安装初始化依赖" -FC yellow
    apt-get --quiet -y update && apt-get --quiet -y install \
      ca-certificates \
      curl \
      gnupg \
      gosu \
      lsb-core \
      sudo \
      wget \
      ;
  fi

  echo
  echo_colored "Installing PX4 dependencies\n安装 PX4 通用依赖" -FC blue
  echo

  sudo apt update -y
  sudo apt install -y \
    astyle \
    build-essential \
    ccache \
    clang \
    clang-tidy \
    cmake \
    cppcheck \
    doxygen \
    file \
    g++ \
    gcc \
    gdb \
    git \
    lcov \
    make \
    ninja-build \
    python-dev \
    python-pip \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    rsync \
    shellcheck \
    unzip \
    xsltproc \
    zip \
    ;
  if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi

  if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
    echo
    echo_colored "Installing Ubuntu 16.04 PX4-compatible ccache version\n安装适配 Ubuntu 16.04 的 ccache 版本" -FC blue
    echo

    CCACHE_VERSION_FOUND=$(dpkg -s ccache | grep Version | awk -F ': ' '{print $2}')
    if [[ $CCACHE_VERSION_FOUND != "3.4.1-1" ]]; then

      sudo apt remove ccache -y
      echo_colored "Some warning/error in this operation is OK\n此操作中出现一些警告或错误是正常的" -FC yellow

      _INSTALL_NAME="ccache_3.4.1-1"
      _INSTALL_PREFIX=ccache
      _INSTALL_FILE=ccache_3.4.1-1_amd64.deb
      _INSTALL_DOWNLOAD_URL=http://launchpadlibrarian.net/356662933/ccache_3.4.1-1_amd64.deb

      download_pkg ${_INSTALL_NAME} ${_INSTALL_PREFIX} ${_INSTALL_FILE} ${_INSTALL_DOWNLOAD_URL}
      sudo apt install "${USER_PKG_DIR}/${_INSTALL_PREFIX}/${_INSTALL_FILE}"
      if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
    fi
  fi

  echo
  echo_colored "Upgrade pip and other python dependencies (both to python2 and python3)\n升级 pip 和 其他 python 依赖（包括 python2 和 python3）" -FC blue
  echo

  python2 -m pip install --upgrade pip &&
    python2 -m pip install --upgrade setuptools wheel &&
    python2 -m pip install -r ${cur_dir}/px4_env_ubuntu_python_requirements_v1.9.txt &&
    python3 -m pip install --upgrade pip &&
    python3 -m pip install --upgrade setuptools wheel &&
    python3 -m pip install -r ${cur_dir}/px4_env_ubuntu_python_requirements_v1.9.txt
  if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi

  echo
  echo_colored "Remove modemmanager, add user serial control mode\n删除 modemmanager，添加用户串口控制权限" -FC blue
  echo

  sudo apt remove modemmanager -y
  if [ -n "$USER" ]; then
    sudo usermod -a -G dialout $USER
  fi
  echo_colored "Some warning/error in this operation is OK\n此操作中出现一些警告或错误是正常的" -FC yellow

  if [[ ${INSTALL_NUTTX:="true"} == "true" ]]; then

    echo
    echo_colored "Installing nuttx dependencies\n安装 nuttx 依赖" -FC blue
    echo

    sudo apt install -y \
      autoconf \
      automake \
      bison \
      bzip2 \
      flex \
      gdb-multiarch \
      gperf \
      libncurses-dev \
      libtool \
      pkg-config \
      vim-common \
      ;
    if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi

    echo
    echo_colored "Clean up old GCC\n清理旧版 GCC" -FC blue
    echo

    sudo apt remove gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi gcc-arm-embedded -y
    sudo add-apt-repository --remove ppa:team-gcc-arm-embedded/ppa -y
    echo_colored "Some warning/error in this operation is OK\n此操作中出现一些警告或错误是正常的" -FC yellow

    echo
    echo_colored "Install GNU Arm Embedded Toolchain: 7-2017-q4-major December 18, 2017\n安装 ARM 嵌入式 GNU 工具链：7-2017-q4-major December 18, 2017 版本" -FC blue
    echo

    _INSTALL_NAME="gcc-arm-none-eabi-7-2017-q4-major"
    _INSTALL_PREFIX=gcc-arm-none-eabi
    _INSTALL_FILE=gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
    _INSTALL_DOWNLOAD_URL=https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
    _INSTALL_DIR=${USER_ENV_DIR}/${_INSTALL_PREFIX}

    NUTTX_GCC_VERSION="7-2017-q4-major"
    if [ $(which arm-none-eabi-gcc) ]; then
      GCC_VER_STR=$(arm-none-eabi-gcc --version)
      GCC_FOUND_VER=$(echo ${GCC_VER_STR} | grep -c "${NUTTX_GCC_VERSION}")
    fi

    if [[ "$GCC_FOUND_VER" == "1" ]]; then
      :
    else
      check_pkg_exist ${_INSTALL_PREFIX} ${_INSTALL_FILE}
      if (($?)); then
        download_pkg ${_INSTALL_NAME} ${_INSTALL_PREFIX} ${_INSTALL_FILE} ${_INSTALL_DOWNLOAD_URL}
        if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
      fi
      mkdir -p ${_INSTALL_DIR}
      tar -C ${_INSTALL_DIR} -jxf ${USER_PKG_DIR}/${_INSTALL_PREFIX}/${_INSTALL_FILE}
      if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi

      exportline="export PATH=${_INSTALL_DIR}/${_INSTALL_NAME}/bin:\$PATH"
      if grep -Fxq "$exportline" $HOME/.profile; then
        :
      else
        echo $exportline >>$HOME/.profile
        LAST_TIPS=$(echo "$LAST_TIPS; RESTART YOUR COMPUTER to complete installation of PX4 development toolchain\n需要重启计算机以完成安装")
      fi
    fi
  fi

  if [[ ${INSTALL_QGC:="true"} == "true" ]]; then

    echo
    echo_colored "Installing QGroundControl\n安装 QGroundControl 地面站" -FC blue
    echo

    if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
      _INSTALL_NAME="QGroundControl-3.5.6"
      _INSTALL_PREFIX=QGroundControl
      _INSTALL_FILE=QGroundControl-3.5.6.AppImage
      _INSTALL_DOWNLOAD_URL=https://github.com/mavlink/qgroundcontrol/releases/download/v3.5.6/QGroundControl.AppImage
      _INSTALL_DIR=${USER_ENV_DIR}/${_INSTALL_PREFIX}
    else
      _INSTALL_NAME="QGroundControl-4.0.9"
      _INSTALL_PREFIX=QGroundControl
      _INSTALL_FILE=QGroundControl-4.0.9.AppImage
      _INSTALL_DOWNLOAD_URL=https://github.com/mavlink/qgroundcontrol/releases/download/v4.0.9/QGroundControl.AppImage
      _INSTALL_DIR=${USER_ENV_DIR}/${_INSTALL_PREFIX}
    fi
    check_env_exist ${_INSTALL_PREFIX} ${_INSTALL_FILE}
    if (($?)); then
      download_pkg ${_INSTALL_NAME} ${_INSTALL_PREFIX} ${_INSTALL_FILE} ${_INSTALL_DOWNLOAD_URL}
      mkdir -p ${_INSTALL_DIR}
      cp "${USER_PKG_DIR}/${_INSTALL_PREFIX}/${_INSTALL_FILE}" "${USER_ENV_DIR}/${_INSTALL_PREFIX}"
      chmod u+x "${USER_ENV_DIR}/${_INSTALL_PREFIX}/${_INSTALL_FILE}"
      echo
      echo_colored "QGroundControl has been installed correctly\nQGroundControl 已经被正确安装" -FC green
    fi

  fi

  if [[ ${INSTALL_SIM:="false"} == "true" ]]; then

    echo
    echo_colored "Installing PX4 simulation dependencies\n安装 PX4 仿真依赖" -FC blue

    echo
    echo_colored "Install simulation general dependencies\n安装仿真通用依赖" -FC blue
    sudo apt install -y \
      git \
      zip \
      cmake \
      build-essential \
      genromfs \
      ninja-build \
      exiftool \
      astyle \
      bc \
      ;
    if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
    # make sure xxd is installed, dedicated xxd package since Ubuntu 18.04 but was squashed into vim-common before
    which xxd >dev/null 2>&1 || sudo apt install xxd -y || sudo apt install vim-common --no-install-recommends -y

    echo
    echo_colored "Install Java environment\n安装 Java 环境" -FC blue
    echo
    if [[ "${UBUNTU_RELEASE}" == "16.04" ]]; then
      java_version=8
    elif [[ "${UBUNTU_RELEASE}" == "18.04" ]]; then
      java_version=11
    elif [[ "${UBUNTU_RELEASE}" == "20.04" ]]; then
      java_version=14
    else
      java_version=8
    fi

    sudo apt -y install ant \
      openjdk-$java_version-jre \
      openjdk-$java_version-jdk \
      ;
    if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi

    # Set Java default
    sudo update-alternatives --set java $(update-alternatives --list java | grep "java-$java_version")

    echo
    echo_colored "Installing ROS Gazebo simulator\n安装 ROS Gazebo 仿真环境" -FC blue
    echo

    which roscore >/dev/null 2>&1
    if (($?)); then
      echo_colored "ROS has NOT been installed correctly, try again\nROS 没有被正确安装，请重试" -FC red
      exit 1
    else
      echo_colored "ROS has been installed correctly\nROS 已经被正确安装" -FC green
      cd ${USER_ROS1_WORKSPACE}
      rospack find mavros >/dev/null 2>&1
      if (($?)); then

        echo
        echo_colored "Build mavros source code.\n编译 mavros 源码" -FC blue
        echo

        if [[ ${PROXY_MODE} == "true" ]]; then PROXY_COMMAND="proxychains"; else PROXY_COMMAND=""; fi
        ${PROXY_COMMAND} rosinstall_generator --rosdistro kinetic mavlink | tee /tmp/mavros.rosinstall &&
          ${PROXY_COMMAND} rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall
        if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
        if [[ ${PROXY_MODE} == "true" ]]; then sed -i "/ProxyChains/d" /tmp/mavros.rosinstall; fi
        wstool merge -t src /tmp/mavros.rosinstall &&
          ${PROXY_COMMAND} wstool update -t src -j4 &&
          rosdep install --from-paths src --ignore-src -y
        if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
        catkin build
        if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
      else
        echo
        echo_colored "Package mavros has been install or build\nmavros 已经安装或编译"
      fi

      echo
      echo_colored "Install gazebo simulator dependencies\n安装 gazebo 仿真器依赖" -FC blue
      echo

      sudo apt install -y \
        protobuf-compiler \
        libeigen3-dev \
        libopencv-dev \
        ;
      if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi

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

      echo
      echo_colored "Install GeographicLib and datasets\n安装 GeographicLib 和地理数据库" -FC blue
      echo

      sudo apt install -y \
        libgeographic-dev \
        geographiclib-tools \
        ros-${ROS_DISTRO}-geographic-msgs \
        ;
      if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
      if [[ ${PROXY_MODE} == "true" ]]; then PROXY_COMMAND="proxychains"; else PROXY_COMMAND=""; fi
      sudo ${PROXY_COMMAND} geographiclib-get-geoids egm96-5 &&
        sudo ${PROXY_COMMAND} geographiclib-get-gravity egm96 &&
        sudo ${PROXY_COMMAND} geographiclib-get-magnetic emm2015
      if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
    fi

  fi
elif
  [[ ${DEVLOPMENT_MODE} == "true" ]]
then
  echo
  echo_colored "Devlopment mode\n开发模式"

  echo
  echo_colored "Install FastRTPS 1.7.1 and FastCDR-1.0.8\n安装 FastRTPS 1.7.1 和 FastCDR-1.0.8" -FC blue
  echo

  _INSTALL_NAME="FastRTPS and FastCDR"
  _INSTALL_PREFIX=eProsima
  _INSTALL_FILE=eprosima_fastrtps-1-7-1-linux.tar.gz
  _INSTALL_DOWNLOAD_URL=https://www.eprosima.com/index.php/component/ars/repository/eprosima-fast-rtps/eprosima-fast-rtps-1-7-1/eprosima_fastrtps-1-7-1-linux-tar-gz
  _INSTALL_DIR=${USER_ENV_DIR}/${_INSTALL_PREFIX}

  check_env_exist ${_INSTALL_PREFIX}
  if (($?)); then
    download_pkg "${_INSTALL_NAME}" ${_INSTALL_PREFIX} ${_INSTALL_FILE} ${_INSTALL_DOWNLOAD_URL}
  fi

  echo
  echo_colored "Decompressing ${_INSTALL_NAME}\n解压缩 ${_INSTALL_NAME}"
  echo
  mkdir -p ${_INSTALL_DIR}
  tar -C ${_INSTALL_DIR} -xzf ${USER_PKG_DIR}/${_INSTALL_PREFIX}/${_INSTALL_FILE} eProsima_FastRTPS-1.7.1-Linux/
  tar -C ${_INSTALL_DIR} -xzf ${USER_PKG_DIR}/${_INSTALL_PREFIX}/${_INSTALL_FILE} requiredcomponents
  tar -C ${_INSTALL_DIR} -xzf ${_INSTALL_DIR}/requiredcomponents/eProsima_FastCDR-1.0.8-Linux.tar.gz

  echo
  echo_colored "Compiling ${_INSTALL_NAME}\n编译 ${_INSTALL_NAME}"
  echo
  (cd ${_INSTALL_DIR}/eProsima_FastCDR-1.0.8-Linux && ./configure --libdir=/usr/lib && make -j${CPUCORES}) &&
    (cd ${_INSTALL_DIR}/eProsima_FastRTPS-1.7.1-Linux && ./configure --libdir=/usr/lib && make -j${CPUCORES})
  if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi

  echo
  echo_colored "Installing ${_INSTALL_NAME} to /usr/lib\n安装 ${_INSTALL_NAME} 到 /usr/lib"
  echo
  (cd ${_INSTALL_DIR}/eProsima_FastCDR-1.0.8-Linux && sudo make install) &&
    (cd ${_INSTALL_DIR}/eProsima_FastRTPS-1.7.1-Linux && sudo make install)
  if (($?)); then echo_colored "Error occurred, try again\n发生错误，请重试" -FC red && exit 1; fi
  rm -rf ${_INSTALL_DIR}/requiredcomponents

fi

echo
echo_colored "===============操作结束===============" -FC light_blue -DE bold
echo

echo_colored "$LAST_TIPS" -FC yellow
