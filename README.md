# NGINX Workshop - Blueprint Building Procedure
    
## Introduction

To be completed

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
    
## ..:: k8s Cluster ::.. Configuration

We are going to build the Kubernetes cluster on these boxes:

````
- k8s-master	- 10.1.1.5 - 10.1.20.60
- k8s-node1 	- 10.1.1.6 - 10.1.20.61
- k8s-node2 	- 10.1.1.7 - 10.1.20.62
````

We will build this with the help of Ansible; as a preliminary work, we need to conofigure ssh keys on these three servers so that infra-server (hosting Ansible) will be able to talk to them. For this reason, copy ~/.ssh/id_rsa.pub content on infra-server

    cat ~/.ssh/id_rsa.pub 	# RUN THIS ON INFRA-SERVER

and repeat the following on the three nodoes of the k8s cluster

    ## RUN THIS ON THE THREE NODES OF THE K8S CLUSTER
    ## FIRST ON ubunut USER
    echo "PAST HERE THE CONTENT OF INFRA-SERVER id_rsa.pub FILE" >> ~/.ssh/authorized_keys
    
    ## THE ON root USERS
    sudo su -
    echo "PAST HERE THE CONTENT OF INFRA-SERVER id_rsa.pub FILE" >> ~/.ssh/authorized_keys
   
Once done with the three servers in the cluster, go back to infra-server connecting as "ubuntu" user and run 

    cd ~/nginx-workshop-udf-blueprint/ansible
    ansible-playbook playbooks/install-k8s-cluster.yaml
    
## ..:: BIG-IP bigip-security ::.. Configuration

Connect to bigip over ssh and change admin and root password to "Default1234!"

    tmsh modify auth password root
    tmsh modify auth user admin password Default1234!
    
We are going to configure BIG-IP L1-L3 with DO (The Declarative Onboarding API package, part of the F5 Automation Toolchain); to do that we will laverage the F5 CLI Docker Container which is already available on your infra-server:

Connect as user ubuntu on the infra-server and initialize the F5 CLI authenticatig to the bigip-security BIG-IP and configure the docker to accept self-signed certificates:

    runf5cli f5 login --authentication-provider bigip --host 10.1.1.9 --user admin
    runf5cli f5 config set-defaults --disable-ssl-warnings true
    
Install the full ATC Package (DO, AS3 and TS)

    runf5cli f5 bigip extension do install
    runf5cli f5 bigip extension as3 install
    runf5cli f5 bigip extension ts install

Now go and check the DO json configuration file for bigip-security

    vim ~/dockerhost-storage/f5-cli/f5-cli/do/10.1.1.9.json
    
then apply it:

    runf5cli f5 bigip extension do create --declaration do/10.1.1.9.json

### big-ip BGP Calico Configuration

    --->>> TBD: ADD HERE BIG-IP BGP CONFIGURATION FOR CALICO <<<---

## ..:: NGINX Controller ::.. Configuration

We are going to build the NGINX Controller on this box:

````
- nginx-controller	- 10.1.1.8 - 10.1.20.70
````

We will build this with the help of Ansible; as a preliminary work, we need to conofigure ssh keys on this server so that infra-server (hosting Ansible) will be able to talk to it. For this reason, copy ~/.ssh/id_rsa.pub content on infra-server

    cat ~/.ssh/id_rsa.pub 	# RUN THIS ON INFRA-SERVER

and do the following on the nginx-controller server box:

    ## RUN THIS ON THE THREE NODES OF THE K8S CLUSTER
    ## FIRST ON ubunut USER
    echo "PAST HERE THE CONTENT OF INFRA-SERVER id_rsa.pub FILE" >> ~/.ssh/authorized_keys
    
    ## THE ON root USERS
    sudo su -
    echo "PAST HERE THE CONTENT OF INFRA-SERVER id_rsa.pub FILE" >> ~/.ssh/authorized_keys

**Be usre to have the controller-installer/ directory in ubuntu hoome on the nginx-controller server**

Once done, go back to infra-server connected as "ubuntu" user and run 

    cd ~/nginx-workshop-udf-blueprint/ansible
    ansible-playbook playbooks/.yaml

## ..:: NGINX Plus Servers ::.. Configuration

We are going to install the NGINX Plus on these two boxes:

````
- nginx-plus-1	- 10.1.1.11 - 10.1.20.11
- nginx-plus-2	- 10.1.1.12 - 10.1.20.12
````

We will build this with the help of Ansible; as a preliminary work, we need to conofigure ssh keys on these two servers so that infra-server (hosting Ansible) will be able to talk to them. For this reason, copy ~/.ssh/id_rsa.pub content on infra-server

    cat ~/.ssh/id_rsa.pub 	# RUN THIS ON INFRA-SERVER

and do the following on the two nginx-plus servers boxes:

    ## RUN THIS ON THE THREE NODES OF THE K8S CLUSTER
    ## FIRST ON ubunut USER
    echo "PAST HERE THE CONTENT OF INFRA-SERVER id_rsa.pub FILE" >> ~/.ssh/authorized_keys
    
    ## THE ON root USERS
    sudo su -
    echo "PAST HERE THE CONTENT OF INFRA-SERVER id_rsa.pub FILE" >> ~/.ssh/authorized_keys

**In order to correctly install nginx-plus, we need the license. Please copy files nginx-repo.key and nginx-repo.crt into the ~/licenses/nplus/ directory on infra-server**

When done, you are ready to install 