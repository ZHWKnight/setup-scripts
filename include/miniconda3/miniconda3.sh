#!/bin/bash

# This script will configure "miniconda3".
#
# Github: https://github.com/zhwknight/setup-scripts

# eval "$(/home/zhw/Envs/miniconda3/bin/conda shell.YOUR_SHELL_NAME hook)"
conda_init_cmd=". ${HOME}/Envs/miniconda3/bin/activate"
conda_init_alias="alias conda-init=\"${conda_init_cmd}\""
if grep -Fxq "$conda_init" ~/.bashrc; then
    :
else
    echo "$conda_init" >>~/.bashrc
fi
eval $conda_init_cmd

conda config --set show_channel_urls yes

tee ~/.condarc <<EOF >>/dev/null
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
EOF
