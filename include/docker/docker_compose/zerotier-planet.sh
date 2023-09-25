#!/bin/bash

SRVS_PATH=${HOME}/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=zerotier-planet
mkdir ${SRV_NAME}

docker image load < zerotier-planet.tar.gz

docker run -d \
  --name ${SRV_NAME} \
  -e TZ=Asia/Shanghai \
  zerotier-planet

echo "Waiting 3 secs for ${SRV_NAME} to start..."
sleep 3

mkdir -p ${SRV_NAME}/var/lib
mkdir -p ${SRV_NAME}/app
docker container cp ${SRV_NAME}:/var/lib/zerotier-one ${SRV_NAME}/var/lib
docker container cp ${SRV_NAME}:/app ${SRV_NAME}
docker container rm -f ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
version: '3'
services:
  ${SRV_NAME}:
    image: zerotier-planet
    container_name: ${SRV_NAME}
    environment:
      - TZ=Asia/Shanghai
    ports:
      - 4000:4000
      - 9993:9993/udp
    volumes:
      - ./var/lib/zerotier-one:/var/lib/zerotier-one
      - ./app/backend/data:/app/backend/data
    restart: always
EOF

srv_include="  - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
