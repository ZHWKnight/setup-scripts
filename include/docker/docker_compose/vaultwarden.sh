#!/bin/bash

SRVS_PATH=$HOME/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=vaultwarden
mkdir ${SRV_NAME}

read -p "Please input database user vaultwarden's password: " _DB_PASSWORD
read -p "Please input vaultwarden's admin token: " _ADMIN_TOKEN

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
version: '3'
services:
    vaultwarden:
        image: vaultwarden/server:latest
        container_name: vaultwarden
        environment:
            - TZ=Asia/Shanghai
            - DATABASE_URL=mysql://vaultwarden:${_DB_PASSWORD}@mariadb/vaultwarden
            - ADMIN_TOKEN=${_ADMIN_TOKEN}
            - LOG_FILE=/data/log/vaultwarden.log
            - LOG_LEVEL=warn
            - EXTENDED_LOGGING=true
            - RUST_BACKTRACE=1
        ports:
            - 8080:80
        volumes:
            - vaultwarden_data:/data/
            - ./web-vault/:/web-vault/
        restart: always
volumes:
    vaultwarden_data:

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
