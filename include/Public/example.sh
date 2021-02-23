#!/bin/bash
# 指定脚本解释器

source $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/general.sh

#General script templet.

if [[ ${DEVLOPMENT_MODE} == "false" ]]; then
  echo
  echo_colored "Deployment mode\n部署模式"

elif [[ ${DEVLOPMENT_MODE} == "true" ]]; then
  echo
  echo_colored "Devlopment mode\n开发模式"
fi

echo
echo_colored "===============操作结束===============" -FC light_blue -DE bold

echo
echo >/dev/null 2>&1
if (($?)); then
  echo_colored "OK.\nOK" -FC red
else
  echo_colored "NO.\nNO" -FC green
fi
echo_colored "$LAST_TIPS" -FC yellow
