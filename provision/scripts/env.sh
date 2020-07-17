# General vars
export HOST_IP=@local_ip
export PRIMARY_HOST_IP=@primary_ip
export DATACENTER=@dc
export PRIMARY_DATACENTER=@primary
export SECONDARY_DATACENTER=@secondary
export HOST_LIST=@list_ips
export SERVER=@server

# Consul env vars
export CONSUL_SERVERS=1
export CONSUL_SCHEME=https
export CONSUL_PORT=8500
export CONSUL_HTTP_ADDR=$CONSUL_SCHEME://$HOST_IP:$CONSUL_PORT
export CONSUL_CACERT=/var/certs/consul-agent-ca.pem
export CONSUL_CLIENT_CERT=/var/certs/@dc-server-consul-0.pem
export CONSUL_CLIENT_KEY=/var/certs/@dc-server-consul-0-key.pem
export CONSUL_HTTP_SSL=true
export CONSUL_ENCRYPT_KEY="apEfb4TxRk3zGtrxxAjIkwUOgnVkaD88uFyMGHqKjIw="
export CONSUL_SSL=true
export CONSUL_HTTP_TOKEN=""

# Nomad env vars
export NOMAD_CACERT=/var/certs/consul-agent-ca.pem
export NOMAD_CLIENT_CERT=/var/certs/@dc-server-consul-0.pem
export NOMAD_CLIENT_KEY=/var/certs/@dc-server-consul-0-key.pem
export NOMAD_SERVERS=1
export NOMAD_ADDR=https://${HOST_IP}:4646

# Vault env vars
export VAULT_CACERT=/var/certs/consul-agent-ca.pem
export VAULT_CLIENT_CERT=/var/certs/@dc-server-consul-0.pem
export VAULT_CLIENT_KEY=/var/certs/@dc-server-consul-0-key.pem
export VAULT_ADDR=https://${HOST_IP}:8200