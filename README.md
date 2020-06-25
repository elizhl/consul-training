# consul-training

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

Done!
