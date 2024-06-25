#!/bin/bash

SRVS_PATH=${HOME}/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=nginx
mkdir ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
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
            - nginx_share:/usr/share/nginx/
            - nginx_config:/etc/nginx/
        restart: always
        labels:
            - "sh.acme.autoload.domain=zhw.link"
        extra_hosts:
            - "host.docker.internal:host-gateway"
volumes:
    nginx_share:
    nginx_config:

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
