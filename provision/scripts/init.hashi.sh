#!/bin/bash

sudo mkdir -p /var/consul/config

# Setup Consul Files
sudo cp /vagrant/provision/consul/system/consul.service /etc/systemd/system/consul.service
sudo cp /vagrant/provision/consul/config/consul.hcl.tmpl /var/consul/config/consul.hcl

# Copy certs
sudo mkdir /var/certs/
sudo cp /vagrant/provision/certs/consul-agent-ca.pem /var/certs/consul-agent-ca.pem
sudo cp /vagrant/provision/certs/dc1-server-consul-0.pem /var/certs/dc1-server-consul-0.pem
sudo cp /vagrant/provision/certs/dc1-server-consul-0-key.pem /var/certs/dc1-server-consul-0-key.pem
sudo cp /vagrant/provision/certs/consul-agent-ca-key.pem /var/certs/consul-agent-ca-key.pem


sudo chmod -R +x /var/consul/config/
sudo chmod -R +x /vagrant/provision/consul/system/


sudo cp /vagrant/provision/scripts/env.sh /etc/environment

sudo sed -i "s/@local_ip/$2/" /etc/environment
sudo sed -i "s/@primary_ip/$2/" /etc/environment
sudo sed -i "s/@dc/$1/" /etc/environment
sudo sed -i "s/@primary/sfo/" /etc/environment
sudo sed -i "s/@secondary/nyc/" /etc/environment
sudo sed -i "s/@list_ips/'[\"172.20.20.11\",\"172.20.20.21\"]'/" /etc/environment
sudo sed -i "s/@server/$3/g" /etc/environment

sudo cat /etc/environment
source /etc/environment

if [ "$1" == "sfo" ]; then 
  echo "Restarting Consul"
  sudo service consul restart
  sudo service consul status
  
  echo "Waiting for Consul leader to bootstrap ACL System"
  sudo bash /vagrant/provision/consul/system/wait_consul_leader.sh

  echo "Bootstraping ACL System"
  sudo bash /vagrant/provision/consul/system/bootstrap.sh

fi

if [ "$1" != "sfo" ]; then
  sudo bash /vagrant/provision/scripts/init.secondaries.sh
fi

echo "SERVERS: =>"
ip_addresses=`echo $3 | sed "s/,/\",\"/g"`
echo "\"$ip_addresses\""
