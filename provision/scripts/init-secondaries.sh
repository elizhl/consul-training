#!/bin/bash
source /etc/environment

CONSUL_HTTP_TOKEN=`curl -s -k https://172.20.20.11:8500/v1/kv/cluster/consul/rootToken | jq  -r '.[].Value'| base64 -d -`
sed -i '/CONSUL_HTTP_TOKEN/d' /etc/environment
echo -e "\nexport CONSUL_HTTP_TOKEN=$CONSUL_HTTP_TOKEN\n" >> /etc/environment

export CONSUL_HTTP_TOKEN=$CONSUL_HTTP_TOKEN

replicationToken=`curl -s -k https://172.20.20.11:8500/v1/kv/cluster/consul/replicationToken | jq  -r '.[].Value'| base64 -d -`

consul acl set-agent-token replication $replicationToken

sudo service consul restart
sudo service consul status

sudo service nomad restart