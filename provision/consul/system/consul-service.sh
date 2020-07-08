#!/bin/bash

. /etc/environment

consul-template -template "/var/consul/config/consul.hcl.tmpl:/var/consul/config/consul.hcl" -once

sudo chmod -R +x "/var/consul/config"
sudo chmod -R +x "/vagrant/provision/consul/system"

exec consul agent -config-dir=/var/consul/config/ >>/var/log/consul.log 2>&1