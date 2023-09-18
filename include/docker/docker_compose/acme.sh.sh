#!/bin/bash

SRVS_PATH=$HOME/Srvs
cd $SRVS_PATH

SRV_NAME=acme.sh
mkdir $SRV_NAME

mkdir -p $SRV_NAME/acme.sh

tee $SRV_NAME/compose.yaml <<EOF >>/dev/null
version: '3'
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
      - $SRVS_PATH/$SRV_NAME/acme.sh/:/acme.sh/
    restart: always
EOF

sed -i "$ a  \  - $SRV_NAME/compose.yaml" compose.yaml

docker compose up -d $SRV_NAME

echo -e "Do you want to deploy certification now?\n你想现在部署证书么？"
read -p "[Y/n]: " _INPUT
case ${_INPUT} in
[yY][eE][sS] | [yY])
  echo -e "Please input Token\n请输入 Token。"
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
      ;

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
  echo -e "Nothing to do, exiting now\n不部署，程序结束。"
  exit 0
  ;;
*)
  echo -e "Invalid input, exiting now\n错误输入，程序退出。"
  exit 1
  ;;
esac