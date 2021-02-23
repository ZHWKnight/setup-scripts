#!/bin/bash

# This script will install "docker".
#
# Github: https://github.com/zhwknight/setup-scripts

# Uninstall old versions
sudo yum remove \
  docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine \
  ;

# SET UP THE REPOSITORY
sudo yum install yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# INSTALL DOCKER ENGINE
sudo yum install \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  ;
sudo systemctl start docker
