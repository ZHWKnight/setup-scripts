#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo -e "Use this script for find live hosts at a C-Class network.
usage: [DEST_NET_SEGMENT]
example: ./ping_live_hosts.sh 192.168.1"
  exit 1
fi

for IP in $(seq 1 254); do
  HOST=$1.$IP
  ping -w 1 $HOST >/dev/null 2>&1 && echo "$HOST is online." &
done
wait

echo "Detect complete!"
