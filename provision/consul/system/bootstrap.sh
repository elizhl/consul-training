#!/bin/bash

. /etc/environment

if [ "$CONSUL_HTTP_SSL" == "true" ]; then
  curl_ssl="--cacert ${CONSUL_CACERT}"
  echo "SSL Enabled"
fi

echo "Bootstrap Consul ACL System"
echo "curl -s $curl_ssl --request PUT $CONSUL_HTTP_ADDR/v1/acl/bootstrap"
response=`curl -s $curl_ssl --request PUT $CONSUL_HTTP_ADDR/v1/acl/bootstrap`
echo $response

rootToken=`echo $response | jq .SecretID | sed s/\"//g`
echo $rootToken

echo "Storing Consul Root Token"
echo "consul kv put cluster/consul/rootToken $rootToken"
CONSUL_HTTP_TOKEN=$rootToken consul kv put cluster/consul/rootToken $rootToken

sed -i '/CONSUL_HTTP_TOKEN/d' /etc/environment
echo -e "\nexport CONSUL_HTTP_TOKEN=$rootToken\n" >> /etc/environment

export CONSUL_HTTP_TOKEN=$rootToken

cp /vagrant/provision/scripts/replication-policy.hcl replication-policy.hcl
cp /vagrant/provision/scripts/replication-token-data.json replication-token-data.json

consul acl policy create -name replication -rules @replication-policy.hcl

consul acl set-agent-token default $rootToken

replication_token=`curl -s $curl_ssl -d @replication-token-data.json --request PUT $CONSUL_HTTP_ADDR/v1/acl/token` 
echo $replication_token

replicationToken=`echo $replication_token | jq .SecretID | sed s/\"//g`
CONSUL_HTTP_TOKEN=$rootToken consul kv put cluster/consul/replicationToken $replicationToken