#!/bin/bash

SRVS_PATH=$HOME/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=mariadb
mkdir ${SRV_NAME}

read -p "Please input database root password: " _PASSWORD

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
services:
    mariadb:
        image: mariadb:latest
        container_name: mariadb
        environment:
            - TZ=Asia/Shanghai
            - MYSQL_ROOT_PASSWORD=${_PASSWORD}
        ports:
            - 3306:3306
        volumes:
            - mariadb_config:/etc/mysql/
            - mariadb_data:/var/lib/mysql/
        restart: always
volumes:
    mariadb_config:
    mariadb_data:

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
