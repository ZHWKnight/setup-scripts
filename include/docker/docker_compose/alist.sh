#!/bin/bash

SRVS_PATH=${HOME}/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=alist
mkdir ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
services:
    alist:
        # image: 'xhofe/alist:latest'
        image: 'xhofe/alist-aria2:latest'
        container_name: alist
        environment:
            - TZ=Asia/Shanghai
            - PUID=1000
            - PGID=1000
            - UMASK=022
        ports:
            - 5244:5244
        volumes:
            - alist_data:/opt/alist/data
        restart: always
volumes:
    alist_data:

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include" compose.yaml
fi

docker compose up -d ${SRV_NAME}
