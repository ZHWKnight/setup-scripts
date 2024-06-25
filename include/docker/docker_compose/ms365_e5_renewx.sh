#!/bin/bash

SRVS_PATH=$HOME/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=ms365_e5_renewx
mkdir ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
services:
    ms365_e5_renewx:
        image: gladtbam/ms365_e5_renewx:latest
        container_name: ms365_e5_renewx
        environment:
            - TZ=Asia/Shanghai
        volumes:
            - ms365_e5_renewx_config:/renewx/Deploy/
            - ms365_e5_renewx_data:/renewx/appdata/
        ports:
            - 1066:1066
        restart: always
volumes:
    ms365_e5_renewx_config:
    ms365_e5_renewx_data:

EOF

if [ ! -f "${SRVS_PATH}/compose.yaml" ]; then
    tee ${SRVS_PATH}/compose.yaml <<EOF >>/dev/null
version: '3'
include:
EOF
fi

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
