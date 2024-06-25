#!/bin/bash

SRVS_PATH=${HOME}/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=zerotier-planet
mkdir ${SRV_NAME}

docker image load < zerotier-planet.tar.gz

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
services:
    zerotier-planet:
        image: zerotier-planet:zt-1.10.6
        container_name: zerotier-planet
        environment:
            - TZ=Asia/Shanghai
        ports:
            - 4000:4000
            - 9993:9993/udp
        volumes:
            - zerotier-planet_zerotier-one:/var/lib/zerotier-one
            - zerotier-planet_data:/app/backend/data
        restart: always
volumes:   
    zerotier-planet_zerotier-one:
    zerotier-planet_data:

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
