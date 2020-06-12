# Hackazon - NGINX KIC, F5 BIG-IP CIS and NGINX App Protect

## Description
With this use case we are going to explore the deployment of a web application in a Kubernetes cluster. Hachazon has two micro-services:

- Frontend: a Vulnerable WEB Front End written in PHP and based on the Apache Web Server
- Backend: a MySQL Database

We are going to deploy the application in our k8s cluster in UDF in a dedicated partition, we will publish the WEB Frontend with a Kubernetes Service (ClusterIP type); an NGINX Kubernetes Ingress Controller (KIC), dedicated to this specific partition, will take care of the URI switching for this application thtough a VS Kubernetes definition.

The NGINX KIC will be configured with a BIG-IP VS ConfigMap (AS3 type) to automatically drive the configuration of BIG-IP in order to expose NGINX KIC's pods to the ourside world.

Two sub use cases are avaiable here:

- **Standard Hackazon software**: we will run a POD with the standard Hackazon Container 
- **Hackazon protected by the NGINX App Protect**: we will run a POD with two conftainers, one of them being the standard hackazon software, the other one as a sidecar proxy running NGINX+ with the App Protect module enabled

## Preprare k8s storage to host Hackazon / Hackazon-NAP Web Content
We need to prepare the storage to allocate the directory structure for this use cases:

````
/usr/local/share/gv/k8s-udf-srtorage
    |
    |-->hackazon
            |
            | --> hackazon
            | --> hackazon-nap
            | --> mysql             # This directory will be automatically create by the mysql POD
````

Connect to infra-server via ssh and execute 

    sudo su -
    cd /usr/local/share/gv/k8s-udf-storage
    mkdir hackazon
    cd hackazon
    git clone https://github.com/rapid7/hackazon.git
    mv hackazon hackazon-nap
    git clone https://github.com/rapid7/hackazon.git
    chown -R www-data:www-data hackazon*

## Preparing k8s cluster to host Hackazon use cases

### If you are using Rancher UI

Anywhere on your computer, download YAML files for hackazon deployment:

    git clone https://github.com/tomminux/hackazon-k8s.git

From UDF, through the BIG-IP component, connect and login with admin user to the Rancher UI, click on k8s-udf kubernetes cluster and on "Projetcs/Namespaces" link. Add a project called "E-Commerce" (Add project -> "E-Commerce" in the text field -> Create) and the click on the add Namespace button next to "Project: E-Commerce". Put "hackazon" in the Name field and click create.

First of all, we need to setup the NGINX Kic and BIG-IP CIS ingegration for the "hackazon" namespace; to do this we need to spin up a k8s-bigip-ctlr pod controller in the kube-system namespace. Go to the System Project in Rancher and, selecting the **kube-system**, import the 1.bigip-k8s-ctlr-deployment.yaml file

We are now ready to deploy the NGINX Kubernetes Ingress Controller. From the main Projects/Namespaces link, click on the "Project: E-Commerce" link and on the "Import YAML" button. Import the file 2.environment-preparation.yaml, this will spin up the NGINX KIC, the Persistent Volume and the mysql needed to operate hackazon. 

If you want to spin up the plan Hackazon Commerce site, import the file hackazon.yaml in the 3a.hackazon directory

If you want to operate the hackazon e-commerce site with the application security provided by NGINX App Protect, you need to build the NGINX+ Sidecar Proxy before; move to the right directory:
    
    cd ~/hackazon-k8s/with-rancher/3b.hackazon-nap/0.docker-build

Copy in this directory your nginx-repo.{key,crt} files and build the container, pushing it to the local UDF Registry:

    docker build . -t registry.f5-udf.com:5000/nginx-nap:latest
    docker push registry.f5-udf.com:5000/nginx-nap:latest

You are now ready to spin up the Hackazon-Nap POD with the two containers: go to Rancher and import the hackazon-nap.yaml file.

### If you are using teh Unix Command Line

This section in the documentation is fo the ones that would like to operate on the unic command line from a host that has kubctl rechability to the k8s clustrer.
Connect to infra-server to the ubunut user with ssh. From there clone the repository 

    cd ~
    git clone https://github.com/tomminux/hackazon-k8s.git

As a first think we are going to prepare the namespace, CIS and KIC: this will create the namespace and will populate it with the KIC, the CIS, Pv and PVC for file storage and the mysql DB

    cd ~/hackazon-k8s/with-command-line/0.namespace-preparation
    kubectl apply -f  0.namespace.yaml
    kubectl apply -f  1.bigip-k8s-ctlr-deployment.yaml
    kubectl apply -f  2.nginx-kic-cis.yaml
    kubectl apply -f  3.pv-pvc.yaml
    kubectl apply -f  4.mysql.yaml

If you want to deploy the standard hackazon (no NGINX App Protect) proceed in the hackazon directory

    cd ~/hackazon-k8s/with-command-line/hackazon
    kubectl apply -f hackazon.yaml

If you want to deploy the hackazon web site protected with the NGINX App Protect Sidecar Proxy, please proceed to the hackazon-nap directory: 

    cd ~/hackazon-k8s/with-command-line/hackazon-nap
    
Since we are going to use NGINX Plus to run the App Protect Module, we need to build NGINX+ Docker Container

    cd 0.docker-build

Copy in this directory your nginx-repo.{key,crt} files and build the container, pushing it to the local UDF Registry:

    docker build . -t registry.f5-udf.com:5000/nginx-nap:latest
    docker push registry.f5-udf.com:5000/nginx-nap:latest

Once you have the docker image in your UDF registry, you can proceed deploying the protected Hackazon Web Commerce Site:

    kubectl apply -f 1.configmap-nginxconf.yaml
    kubectl apply -f 2.hackazon-nap.yaml

The Hackazon application is now deployed and available. 

## Checks

- In the Rancher UI, multiple pods will appear. 
- In BIG-IP TMUI, nginx-ingres VSes should appear under Virtual Servers -> hackazon partition. They should be green and they should have a pool resource with 2 pool members, corresponding to the two pods running NGINX KIC for this Namespace.
- From win-jumphost, open chrome and try to connect to http://hackazon.f5-udf.com