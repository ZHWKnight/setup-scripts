#!/bin/bash

SRVS_PATH=$HOME/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=ms365_e5_renewx
mkdir ${SRV_NAME}

docker run -d \
  --name ${SRV_NAME} \
  -e TZ=Asia/Shanghai \
  gladtbam/ms365_e5_renewx:latest

echo "Waiting 3 secs for ${SRV_NAME} to start..."
sleep 3

mkdir -p ${SRV_NAME}/renewx
docker container cp ${SRV_NAME}:/renewx/Deploy ${SRV_NAME}/renewx
docker container cp ${SRV_NAME}:/renewx/appdata ${SRV_NAME}/renewx
docker container cp ${SRV_NAME}:/renewx/wwwroot ${SRV_NAME}/renewx
docker container rm -f ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
version: '3'
services:
  ${SRV_NAME}:
    image: gladtbam/ms365_e5_renewx:latest
    container_name: ${SRV_NAME}
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ${SRVS_PATH}/${SRV_NAME}/renewx/Deploy/:/renewx/Deploy/
      - ${SRVS_PATH}/${SRV_NAME}/renewx/appdata/:/renewx/appdata/
      - ${SRVS_PATH}/${SRV_NAME}/renewx/wwwroot/:/renewx/wwwroot
    ports:
      - 1066:1066
    restart: always
EOF

if [ ! -f "${SRVS_PATH}/compose.yaml" ]; then
    tee ${SRVS_PATH}/compose.yaml <<EOF >>/dev/null
version: '3'
include:
EOF
fi

srv_include="  - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
