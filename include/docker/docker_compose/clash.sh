#!/bin/bash

SRVS_PATH=${HOME}/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=clash
mkdir ${SRV_NAME}

cd ${SRV_NAME}
git clone https://github.com/Dreamacro/clash-dashboard.git
# git clone https://github.com/haishanh/yacd.git yacd-dashboard
# wget -O config.yaml $your-proxy-url
# wget https://github.com/Dreamacro/maxmind-geoip/releases/download/20220412/Country.mmdb
cd ..

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
version: '3'
services:
    clash:
        # image: dreamacro/clash-premium
        image: dreamacro/clash
        container_name: clash
        environment:
            - TZ=Asia/Shanghai
        ports:
            - 7890:7890
            - 7891:7891
            - 9090:9090 # external controller (Restful API)
        # TUN
        # cap_add:
        #   - NET_ADMIN
        # devices:
        #   - /dev/net/tun
        volumes:
            - clash_config:/root/.config/clash/
            - ./clash-dashboard:/ui
            # - ./yacd-dashboard:/ui
        restart: always
volumes:
    clash_config:

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include" compose.yaml
fi

docker compose up -d ${SRV_NAME}
