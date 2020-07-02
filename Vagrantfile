Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.vm.box = "ubuntu/xenial64"
  config.vm.provision "shell", path: "provision/scripts/install.sh", args: "", privileged: false
  
  ['sfo', 'nyc'].each do |dc|
    #ip_addresses = "172.20.20.11,172.20.20.21"
    ip_prefix = dc == 'sfo' ? '172.20.20.11' : dc == 'nyc' ? '172.20.20.21' : '172.20.20.31'
    ip_prefix_client = dc == 'sfo' ? '172.20.20.12' : dc == 'nyc' ? '172.20.20.22' : '172.20.20.31'

    config.vm.define "#{dc}-consul-server" do |cs|
      cs.vm.hostname = "#{dc}-consul-server"
      cs.vm.network "private_network", ip: "#{ip_prefix}"
      cs.vm.provision "shell", path: "provision/scripts/init.hashi.sh", args: "#{dc} #{ip_prefix} true", privileged: false
      cs.vm.provision "shell", path: "provision/scripts/install.dnsmasq.sh", privileged: false

      cs.vm.provision "shell", privileged: false, inline: <<-EOF
        echo "Vagrant Box provisioned!"
      EOF
    end

    config.vm.define "#{dc}-consul-client" do |cs|
      cs.vm.hostname = "#{dc}-consul-client"
      cs.vm.network "private_network", ip: "#{ip_prefix_client}"
      cs.vm.provision "shell", path: "provision/scripts/init.hashi.sh", args: "#{dc} #{ip_prefix_client} false", privileged: false
      cs.vm.provision "shell", path: "provision/scripts/install.dnsmasq.sh", privileged: false

      cs.vm.provision "shell", privileged: false, inline: <<-EOF
        echo "Vagrant Box provisioned!"
      EOF
    end
  end


end
