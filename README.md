# consul-training

### Consul cluster
You need: Vagrant and VirtualBox

Clone the project then run:

    vagrant status
    vagrant up

In case you want o delete everything run 
      
    vagrant destroy

When all the proccess is finished run 

    vagrant ssh client-1
    
* Inside run

        sudo su
        service consul start
        service consul status

Now we do the same with client 2

    vagrant ssh client-2

* Inside run

        sudo su
        service consul start
        service consul status

Now with the server
  
    vagrant ssh sfo-consul-server

* Inside run

        sudo su
        service consul start
        service consul status

        export CONSUL_HTTP_ADDR=172.20.20.11:8500

        consul acl bootstrap

  Take the Secret ID and then run

        consul members -token=[SecretID]

You have to see 1 server and two clients

Then in a browser go to https://172.20.20.11:8500

Paste your Secret ID and you will see all the consul ui options

### Terraform Provider

On main.tf you can add the set of values you need to save un the Key/Value store. Create an enviroment variable for the token and change the values of address, data center and path.

Run

    terraform init
    terraform plan
    terraform apply

You can check the created values in the Consul UI

### Service configuration and Health Checking

    vagrant ssh consul-client-2

You need to run an aplication inside one of your consul clients. Can be whatever you want at any port

Add this code to your consul client configuration file: 
    
    tokens = {
        default = "[your_token]"
    }

And copy
        
    provision/consul/config/service-1.json (outside vagrant) to /var/config/consul/service-1.json (inside vagrant)

Change in /var/config/consul/service-1.json your port, address, http, name, header and body. Save it and run
    
    consul reload

You are going to see requests to your app every 10 seconds or the interval you choose and in the Consul UI on services tab you can see your app running and if the health checking succed or failed

### Consul template

We change install.sh, init.hashi.sh and we added a new file to replace all consul.hcl files. This file has the .tmpl extension that means is our file with variables. Those variables need to be populated so we need a new other fiile called env.sh that has all the values for the variables. 
Now that we have all the new files and configurations we need to run our machines so we can see the tmpl populated.

When everything is running you should see as members your consul client and consul server

### Multiple datacenter

In the vagrant file we already have the code to generate 2 clients and 2 servers. You just need to run
    
    vagrant up

### SSL

You need to add the ssl params in you hcl config file then create the certs and the variables and reload you consul configuration

If we run this with the template we are going to see as consul members a server and a client on each server now we want our datacenters to comunicate so we need consul federation

### Consul Federation
For this we need to add a line int he config hcl 
    
    retry_join_wan = [hosts_list]

then in your primary datacenter run 

    consul acl bootstrap

then in both servers run 
    
    consul acl set-agent-token default <token>

Now you need to configure the replication token. Visit https://learn.hashicorp.com/consul/day-2-agent-authentication/acl-replication to do this. 


Done!
