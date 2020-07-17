#!/bin/bash
set -e

# exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

. /etc/environment

if [ "$CONSUL_HTTP_SSL" == "true" ]; then
  curl_ssl="--cacert ${CONSUL_CACERT}"
fi

if [ -n $CONSUL_HTTP_TOKEN ]; then
	echo "Setting consul token"
	header="--header \"X-Consul-Token: ${CONSUL_HTTP_TOKEN}\""
fi

vault_url="$VAULT_ADDR/v1/sys"
rootToken=""

function vaultConfig {
  echo "curl -s --cacert $VAULT_CACERT $vault_url/init"
  initResponse=`curl -s --cacert $VAULT_CACERT $vault_url/init`
  echo "Response of initialization: $initResponse"

  isInitialized=`echo $initResponse | jq .initialized`
  if [ "$isInitialized" == "false" ];  then

    echo "curl -s --cacert $VAULT_CACERT -X PUT -H Content-Type: application/json -d {secret_shares:5,secret_threshold:5} $vault_url/init"
    initVaultResponse=`curl -s --cacert $VAULT_CACERT -X PUT -H "Content-Type: application/json" -d '{"secret_shares":5,"secret_threshold":5}' $vault_url/init`
    echo $initVaultResponse
    error=`echo $initVaultResponse | jq .errors`

    if [ -z "$error" ];  then
      exit -1
    fi

    keys=`echo $initVaultResponse | jq .keys`
    rootToken=`echo $initVaultResponse | jq .root_token | sed s/\"//g`

    echo $keys > file.json

    vaultConsulKV "file" "cluster/vault/unsealKeys"
    vaultConsulKV $rootToken "cluster/vault/rootToken"

    rm file.json

    unsealVault "${keys[@]}"

  elif [ "$isInitialized" == "true" ]; then
    echo "Already initialized"
    keysFromConsul=`curl -s $curl_ssl $header -X GET $CONSUL_HTTP_ADDR/v1/kv/cluster/vault/unsealKeys | jq -r '.[].Value' | base64 -d -`
    rootToken=`curl -s $curl_ssl $header -X GET $CONSUL_HTTP_ADDR/v1/kv/cluster/vault/rootToken | jq -r '.[].Value' | base64 -d -`
    unsealVault "${keysFromConsul[@]}"
  else 
    echo "an unexpected error happened"
    exit -1
  fi

  sed -i '/VAULT_TOKEN/d' /etc/environment
  echo -e "export VAULT_TOKEN=$rootToken\n" >> /etc/environment

}

function unsealVault {
  keys=$1
  keysCount=`echo $keys | jq '. | length'`

  if [ $keysCount > 0 ]; then
    echo "curl -s $curl_ssl $header $CONSUL_HTTP_ADDR/v1/catalog/service/vault"
    servers=`curl -s $curl_ssl $header $CONSUL_HTTP_ADDR/v1/catalog/service/vault`
    serversCount=`echo $servers | jq '. | length'`
    echo $servers
    
    for i in $(seq 1 $serversCount); do

      server=`echo $servers | jq .[$((i-1))].Address | sed  's/"//g'`

      while true; do
        echo "https://$server:8200/v1/sys"
        vault_url="https://$server:8200/v1/sys"
        r=`curl -s --cacert $VAULT_CACERT $vault_url/seal-status | jq .sealed`
        echo $r
        if [ "$r" == "true" ];  then
          for j in in $(seq 1 $keysCount); do
            key=`echo $keys | jq .[$((j-1))]`
            
            command="curl -s --cacert $VAULT_CACERT -X PUT -H 'Content-Type: application/json' -d '{\"key\":$key}' https://${server}:8200/v1/sys/unseal"
            request=`eval $command`
            ur=`echo $request | jq .sealed`
            if [ "$ur" == "true" ];  then
              echo "Vault steal unsealed numer of key applied $j"
            elif [ "$ur" == "false" ]; then
              echo "Vault server: $server has been unsealed"
              break
            else 
              echo "Vault unseal failed for server $server with response $(echo $result | jq .response)"
              break
            fi
          done
        else 
          echo "Vault successfully unsealed"
          break
        fi
      done
    done
  fi
}

function vaultConsulKV {
  data=$1
  path=$2
  url="$CONSUL_HTTP_ADDR/v1/kv/$path"

  echo "curl -s $curl_ssl $header  --request PUT -H Content-Type: application/json --data $data $url"

  if [ "$data" == "file" ]; then
   curl -s $curl_ssl $header  --request PUT -H "Content-Type: application/json" --data @file.json $url
  else
   curl -s $curl_ssl $header  --request PUT -H "Content-Type: application/json" --data $data $url
  fi
}

function main {
  
  echo "curl -s $curl_ssl $header -X GET $CONSUL_HTTP_ADDR/v1/kv/cluster/vault/vaultUnseal"
  vaultStart=`curl -s $curl_ssl $header -X GET $CONSUL_HTTP_ADDR/v1/kv/cluster/vault/vaultUnseal | jq  -r '.[].Value'| base64 -d -`
  echo "Response from consul kv / unsealVault value: $vaultStart"

  if [ -z "$vaultStart" ];  then
    echo "STARTING TO UNSEAL VAULT"
    vaultConfig
    vaultConsulKV "true" "cluster/vault/vaultUnseal"
  else
    echo "Vault Already unsealed"
  fi
}

main