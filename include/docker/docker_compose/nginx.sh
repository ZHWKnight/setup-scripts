#!/bin/bash

SRVS_PATH=$HOME/Srvs
cd $SRVS_PATH

SRV_NAME=nginx
mkdir $SRV_NAME

docker run -d \
  --name nginx \
  -e TZ=Asia/Shanghai \
  nginx:latest

mkdir -p $SRV_NAME/etc
mkdir -p $SRV_NAME/usr/share
docker container cp nginx:/etc/nginx $SRV_NAME/etc
docker container cp nginx:/usr/share/nginx $SRV_NAME/usr/share
docker container rm -f nginx

tee $SRV_NAME/compose.yaml <<EOF >>/dev/null
version: '3'
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    environment:
      - TZ=Asia/Shanghai
    ports:
      - 80:80
      - 443:443
    volumes:
      - $SRVS_PATH/$SRV_NAME/usr/share/nginx/:/usr/share/nginx/
      - $SRVS_PATH/$SRV_NAME/etc/nginx/:/etc/nginx/
    restart: always
    labels:
      - "sh.acme.autoload.domain=zhw.link"
EOF

sed -i "$ a  \  - $SRV_NAME/compose.yaml" compose.yaml

docker compose up -d $SRV_NAME
