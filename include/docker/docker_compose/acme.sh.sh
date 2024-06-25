#!/bin/bash

SRVS_PATH=$HOME/Srvs
mkdir ${SRVS_PATH}
cd ${SRVS_PATH}

SRV_NAME=acme.sh
mkdir ${SRV_NAME}

tee ${SRV_NAME}/compose.yaml <<EOF >>/dev/null
services:
    acme.sh:
        image: neilpang/acme.sh:latest
        command: daemon
        container_name: acme.sh
        environment:
            - TZ=Asia/Shanghai
        network_mode: "host"
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock
            - acme.sh_data:/acme.sh/
        restart: always
volumes:
    acme.sh_data:

EOF

srv_include="    - ${SRV_NAME}/compose.yaml"
if grep -Fxq "$srv_include" compose.yaml; then
    echo "compose.yaml already includes ${SRV_NAME}/compose.yaml"
    :
else
    sed -i "/^include/a\\$srv_include"  compose.yaml
fi

docker compose up -d ${SRV_NAME}

echo -e "Do you want to deploy certification now?"
read -p "[Y/n]: " _INPUT
case ${_INPUT} in
[yY][eE][sS] | [yY])
    echo -e "Please input Token of CloudFlare"
    read -p "CF_Token: " _TOKEN

    TARGET_DOMAIN=zhw.link
    docker exec acme.sh --register-account -m zhw@mail.zhw.link 
    docker exec \
        -e CF_Token=${_TOKEN} \
        acme.sh --issue --dns dns_cf \
            -d ${TARGET_DOMAIN} \
            -d *.${TARGET_DOMAIN} \
            -d *.service.${TARGET_DOMAIN} \
            -d *.static.${TARGET_DOMAIN} \
            -d *.ddns.${TARGET_DOMAIN} \
            -d *.vlan.${TARGET_DOMAIN} \
            -d *.netmaker.${TARGET_DOMAIN} \
            ;

    docker exec nginx mkdir /etc/nginx/ssl/${TARGET_DOMAIN}
    docker exec \
        -e DEPLOY_DOCKER_CONTAINER_LABEL="sh.acme.autoload.domain=${TARGET_DOMAIN}" \
        -e DEPLOY_DOCKER_CONTAINER_KEY_FILE="/etc/nginx/ssl/${TARGET_DOMAIN}/${TARGET_DOMAIN}.key" \
        -e DEPLOY_DOCKER_CONTAINER_CERT_FILE="/etc/nginx/ssl/${TARGET_DOMAIN}/${TARGET_DOMAIN}.cer" \
        -e DEPLOY_DOCKER_CONTAINER_CA_FILE="/etc/nginx/ssl/${TARGET_DOMAIN}/ca.cer" \
        -e DEPLOY_DOCKER_CONTAINER_FULLCHAIN_FILE="/etc/nginx/ssl/${TARGET_DOMAIN}/fullchain.cer" \
        -e DEPLOY_DOCKER_CONTAINER_RELOAD_CMD="service nginx force-reload" \
        acme.sh --deploy -d ${TARGET_DOMAIN} --deploy-hook docker
    ;;
[nN][oO] | [nN])
    echo -e "Nothing to do, exiting now"
    exit 0
    ;;
*)
    echo -e "Invalid input, exiting now"
    exit 1
    ;;
esac