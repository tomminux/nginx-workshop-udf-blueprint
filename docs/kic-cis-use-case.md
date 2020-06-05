# Hackazon - NGINX Kubernetes Ingress Controller and F5 BIG-IP Container Ingress Services

## Description
With this use case we are going to explore the deployment of a web application in a Kubernetes cluster. Hachazon has two micro-services:

- Frontend: a Vulnerable WEB Front End written in PHP and based on the Apache Web Server
- Backend: a MySQL Database

We are going to deploy the application in our k8s cluster in UDF in a dedicated partition, we will publish the WEB Frontend with a Kubernetes Service (ClusterIP type); an NGINX Kubernetes Ingress Controller (KIC), dedicated to this specific partition, will take care of the URI switching for this application thtough a VS Kubernetes definition.

The NGINX KIC will be configured with a BIG-IP VS ConfigMap (AS3 type) to automatically drive the configuration of BIG-IP in order to expose NGINX KIC's pods to the ourside world.

## Preprare k8s storage to host Hackazon Web Content
Connect to infra-server via ssh and execute 

    sudo su -
    cd /usr/local/share/gv/k8s-udf-storage
    git clone https://github.com/rapid7/hackazon.git
    chown -R www-data:www-data hackazon

## Creating the Projetc and the Namespace for Hackazon

Anywhere on your computer, download YAML files for hackazon deployment:

    git clone https://github.com/tomminux/hackazon-k8s.git

From UDF, through the BIG-IP component, connect and login with admin user to the Rancher UI, click on k8s-udf kubernetes cluster and on "Projetcs/Namespaces" link. Add a project called "Hackazon" (Add project -> "Hackazon" in the text field -> Create) and the click on the add Namespace button next to "Project: Hackazon". Put "hackazon" in the Name field and click create.

Now click on the "Project: Hackazon", Resources -> Workloads and select the "Import YAML" button. Select "Namespace: Import all resources into a specific namespace", Click on "Read from a File" and select the file "1.nginx-kic.yaml" from the just cloned repository.

Repeat the procedure to import the "2.hackazon.yaml" file 