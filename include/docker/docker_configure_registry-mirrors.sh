#!/bin/bash

# This script will set docker-registry-mirrors to localization.
#
# Github: https://github.com/zhwknight/setup-scripts
#
## 部分内部访问的镜像加速服务
# [Azure 中国镜像](https://dockerhub.azk8s.cn)
# [腾讯云](https://mirror.ccs.tencentyun.com)

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF >>/dev/null
{
  "registry-mirrors": [
    "https://1rxfvawf.mirror.aliyuncs.com",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
