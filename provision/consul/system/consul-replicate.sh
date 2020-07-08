#!/bin/bash
. /etc/environment

if [ "$DATACENTER" == "nyc" ]; then
  exec consul-replicate -consul-addr=$HOST_IP:$CONSUL_PORT -prefix "app/@sfo" -prefix "app2/@sfo" -prefix "cluster/@sfo" -log-level debug >>/var/log/consul-replicate.log 2>&1
fi