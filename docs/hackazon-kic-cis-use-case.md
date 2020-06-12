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

From UDF, through the BIG-IP component, connect and login with admin user to the Rancher UI, click on k8s-udf kubernetes cluster and on "Projetcs/Namespaces" link. Add a project called "Hackazon" (Add project -> "Hackazon" in the text field -> Create) and the click on the add Namespace button next to "Project: Hackazon". Put "hackazon" in the Name field and click create.

First of all, we need to setup the NGINX Kic è BIG-IP CIS ingegration for the "hackazon" namespace; to do this we need to spin up a k8s-bigip-ctlr pod controller in the kube-system namespace. 

TBC TBC TBC 

### If you are using teh Unix Command Line

TBC TBC TBC

## Checks

- In the Rancher UI, multiple pods will appear. 
- In BIG-IP TMUI, nginx-ingres VSes should appear under Virtual Servers -> hackazon partition. They should be green and they should have a pool resource with 2 pool members, corresponding to the two pods running NGINX KIC for this Namespace.
- From win-jumphost, open chrome and try to connect to http://hackazon.f5-udf.com