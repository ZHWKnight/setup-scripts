#!/bin/bash

SRVS_PATH=${HOME}/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=nginx
mkdir ${SRV_NAME}

docker run -d \
  --name ${SRV_NAME} \
  -e TZ=Asia/Shanghai \
  nginx:latest

echo "Waiting 3 secs for ${SRV_NAME} to start..."
sleep 3

mkdir -p ${SRV_NAME}/etc
mkdir -p ${SRV_NAME}/usr/share
docker container cp ${SRV_NAME}:/etc/nginx ${SRV_NAME}/etc
docker container cp ${SRV_NAME}:/usr/share/nginx ${SRV_NAME}/usr/share
docker container rm -f ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
version: '3'
services:
  ${SRV_NAME}:
    image: nginx:latest
    container_name: ${SRV_NAME}
    environment:
      - TZ=Asia/Shanghai
    ports:
      - 80:80
      - 443:443
    volumes:
      - ${SRVS_PATH}/${SRV_NAME}/usr/share/nginx/:/usr/share/nginx/
      - ${SRVS_PATH}/${SRV_NAME}/etc/nginx/:/etc/nginx/
    restart: always
    labels:
      - "sh.acme.autoload.domain=zhw.link"
EOF

srv_include="  - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
