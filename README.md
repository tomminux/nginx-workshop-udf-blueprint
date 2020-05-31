# NGINX Workshop - Blueprint Building Procedure

## TMP

    cd ~/paoloData/dev/git-cloned ; tar zcvf /tmp/tmp.tgz nginx-workshop-udf-blueprint ; scp -i ~/.ssh/digitalocean /tmp/tmp.tgz paolo@174.138.13.130:. # toPdo
    
    cd ~ ; rm -rf nginx-workshop-udf-blueprint ; scp paolo@174.138.13.130:tmp.tgz . ; tar zxvf tmp.tgz ; rm tmp.tgz ; cp dockerhost-storage/registry/ca-certificates/registry.* nginx-workshop-udf-blueprint/ansible/playbooks/files/docker-files/. ; cd nginx-workshop-udf-blueprint/ansible/ # init repo
    
## Introduction

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque vulputate justo ante, sed consectetur metus finibus sed. Ut eu massa imperdiet, vehicula justo vel, ornare justo. Sed rhoncus hendrerit lacus, id rutrum dolor sagittis eget. Phasellus lacinia, arcu sagittis faucibus eleifend, metus lacus iaculis nulla, ac hendrerit dolor dolor sed purus. Vestibulum ultrices, lectus id fermentum accumsan, dui erat feugiat ante, nec pellentesque metus nisi vitae sapien. Nam pharetra porttitor orci vel ornare. Nam pulvinar turpis ac magna dictum, eu tempor nisi venenatis. Sed mollis eros ac risus semper, ac convallis libero tristique. Curabitur tincidunt nisl at quam malesuada, ac aliquet ante tempor. Fusce eleifend consectetur ornare. Phasellus egestas ante non dolor aliquet vehicula. Sed euismod ex enim, vel tempus urna pulvinar vel. Duis id lobortis felis.

## ..:: infra-server ::.. Initial configuration 

"infra-server" stands for Infrastructure Server and we will configure and use this ubuntu box for administration purposes (i.e. administering the Kubernete cluster), as a docker host to run multiple infrastructure dockers containers. 

### Network Configuration

infra-server will be attahced to two networks

- management Network: 		10.1.1.4  
- internal Network: 		10.1.20.20

### Pre-Ansible setup

Connect to the inra-server on user ubuntu with ssh and clone the nginx-workshop-udf-blueprint form github and execute the initializaiont script for this server:

    git clone https://github.com/tomminux/nginx-workshop-udf-blueprint.git
    cd nginx-workshop-udf-blueprint
    sh ./init-scripts/infra-server.sh
    
This script will finish rebooting the box. After the reboot, connect to the infra-server again and issue this command:

    cd nginx-workshop-udf-blueprint
    sh ./init-scripts/infra-server-postReboot.sh
    
infra-serer is now ready to execute Ansible Playbooks to configure all the other building block of this blueprint.

### infra-server Ansible playbook

Connect to infra-server via ssh and generate self-signed certificate and key for the private docker registry

    cd ~/nginx-workshop-udf-blueprint/ansible/playbooks/files/docker-files/
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 3650 -out registry.crt
    
We are now going to launch an Ansible playbook to fully configure this server: please review **carefully** this file 

    vim ~/nginx-workshop-udf-blueprint/ansible/inventory/hosts
    
to set correct IP Addresses based on your UDF environment. The most important thing is to set the correct name of the secondary interface of hosts: if you depoyed in AWS, the second interface will most probably be "eth1", while in UDF Hypervisor it will be "ens6". Please check with this command

    ifconfig -a

When finished personalizing the Ansible inventory hosts file, execute the Ansible playbook to complete this server's configuration

    cd ~/nginx-workshop-udf-blueprint/ansible
    ansible-playbook playbooks/infra-server.yaml
    

 
