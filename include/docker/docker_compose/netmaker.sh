#!/bin/bash

SRVS_PATH=${HOME}/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=netmaker
mkdir ${SRV_NAME}

PUBLIC_IP=$(curl -s myip4.ipip.net | grep -Po 'IP：\K[\d.]+')
DOCKER0_IP=$(docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}')

docker run -d \
    --name ${SRV_NAME} \
    -e TZ=Asia/Shanghai \
    -e NETMAKER_BASE_DOMAIN=netmaker.zhw.link
    -e SERVER_HOST=${PUBLIC_IP} \
    -e COREDNS_ADDR=${PUBLIC_IP} \
    -e GRPC_SSL=off  \
    -e DNS_MODE=on \
    -e CLIENT_MODE=on \
    -e API_PORT=8081 \
    -e GRPC_PORT=50051 \
    -e SERVER_GRPC_WIREGUARD=off \
    -e CORS_ALLOWED_ORIGIN=* \
    -e DATABASE=sqlite \
    -v /usr/bin/wg:/usr/bin/wg \
    --network=host \
    --cap-add=NET_ADMIN \
    gravitl/netmaker:latest

echo "Waiting 3 secs for ${SRV_NAME} to start..."
sleep 3

mkdir -p ${SRV_NAME}/etc/nginx
mkdir -p ${SRV_NAME}/usr/share/nginx
docker container cp ${SRV_NAME}:/etc/nginx ${SRV_NAME}/etc
docker container cp ${SRV_NAME}:/usr/share/nginx ${SRV_NAME}/usr/share
docker container rm -f ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
services:
    netmaker:
        image: gravitl/netmaker:latest
        container_name: netmaker
        environment:
            - TZ=Asia/Shanghai
            - SERVER_HOST=${PUBLIC_IP}
            - COREDNS_ADDR=${PUBLIC_IP}
            - GRPC_SSL=off
            - DNS_MODE=on
            - CLIENT_MODE=on
            - API_PORT=8081
            - GRPC_PORT=50051
            - SERVER_GRPC_WIREGUARD=off
            - CORS_ALLOWED_ORIGIN=*
            - DATABASE=sqlite
        volumes:
            - /etc/netclient/config:/etc/netclient/config
            - dnsconfig:/root/config/dnsconfig
            - /usr/bin/wg:/usr/bin/wg
            - /data/sqldata/:/root/data
        network_mode: host
        cap_add:
            - NET_ADMIN
        restart: always
    netmaker-ui:
        depends_on:
            - netmaker
        image: gravitl/netmaker-ui:latest
        container_name: netmaker-ui
        environment:
            - BACKEND_URL=http://${PUBLIC_IP}:8081
        network_mode: host
        ports:
            - 80:80
        links:
            - netmaker:api
        restart: always
    coredns:
        depends_on:
            - netmaker
        image: coredns/coredns:latest
        container_name: coredns
        command: -conf /root/dnsconfig/Corefile
        network_mode: host
        volumes:
            - dnsconfig:/root/dnsconfig
        restart: always
volumes:
    dnsconfig: {}

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "${srv_include}" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\${srv_include}"  compose.yaml
fi

docker compose up -d ${SRV_NAME}
