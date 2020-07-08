#!/bin/bash

sudo mkdir -p /var/consul/config
sudo mkdir -p /var/nomad/config
sudo mkdir -p /var/vault/config

# Setup Consul Files
sudo cp /vagrant/provision/consul/system/consul.service /etc/systemd/system/consul.service
sudo cp /vagrant/provision/consul/system/csreplicate.service /etc/systemd/system/csreplicate.service
sudo cp /vagrant/provision/consul/config/consul.hcl.tmpl /var/consul/config/consul.hcl.tmpl

# Setup Nomad Files
sudo cp /vagrant/provision/nomad/system/nomad.service /etc/systemd/system/nomad.service
sudo cp /vagrant/provision/nomad/config/nomad.hcl.tmpl /var/nomad/config/nomad.hcl.tmpl

# Setup Vault Files
sudo cp /vagrant/provision/vault/system/vault.service /etc/systemd/system/vault.service
sudo cp /vagrant/provision/vault/config/vault.hcl.tmpl /var/vault/config/vault.hcl.tmpl

# Setup Docker files
sudo cp /vagrant/provision/docker/daemon.json.tmpl /etc/docker/daemon.json.tmpl

# Copy certs
sudo mkdir /var/certs/
sudo cp /vagrant/provision/certs/consul-agent-ca.pem /var/certs/consul-agent-ca.pem
sudo cp /vagrant/provision/certs/consul-agent-ca-key.pem /var/certs/consul-agent-ca-key.pem

sudo cp /vagrant/provision/certs/sfo-server-consul-0.pem /var/certs/sfo-server-consul-0.pem
sudo cp /vagrant/provision/certs/sfo-server-consul-0-key.pem /var/certs/sfo-server-consul-0-key.pem
sudo cp /vagrant/provision/certs/nyc-server-consul-0.pem /var/certs/nyc-server-consul-0.pem
sudo cp /vagrant/provision/certs/nyc-server-consul-0-key.pem /var/certs/nyc-server-consul-0-key.pem


sudo chmod -R +x /var/consul/config/
sudo chmod -R +x /vagrant/provision/consul/system/

sudo chmod -R +x /var/nomad/config/
sudo chmod -R +x /vagrant/provision/nomad/system/

sudo chmod -R +x /var/vault/config/
sudo chmod -R +x /vagrant/provision/vault/system/


sudo cp /vagrant/provision/scripts/env.sh /etc/environment

sudo sed -i "s/@local_ip/$2/" /etc/environment
sudo sed -i "s/@primary_ip/$2/" /etc/environment
sudo sed -i "s/@dc/$1/" /etc/environment
sudo sed -i "s/@primary/sfo/" /etc/environment
sudo sed -i "s/@secondary/nyc/" /etc/environment
sudo sed -i "s/@list_ips/'[\"172.20.20.11\",\"172.20.20.21\"]'/" /etc/environment
sudo sed -i "s/@server/$3/g" /etc/environment

sudo cat /etc/environment

echo "Restarting Consul"
sudo service consul restart
sudo service consul status

echo "Restarting Nomad"
sudo service nomad restart
sudo service nomad status

echo "Restarting Vault"
sudo service vault restart
sudo service vault status
