# Wordpress - NGINX Kubernetes Ingress Controller and F5 BIG-IP Container Ingress Services

## Description
With this use case we are going to explore the deployment of a web application in a Kubernetes cluster. Wordpress has two micro-services:

- Frontend: Wordpress WEB Front End written in PHP and running on the NGINX Unit App Server.
- Backend: a MySQL Database

We are going to deploy the application in our k8s cluster in UDF in a dedicated partition, we will publish the WEB Frontend with a Kubernetes Service (ClusterIP type); an NGINX Kubernetes Ingress Controller (KIC), dedicated to this specific partition, will take care of the URI switching for this application thtough a VS Kubernetes definition.

The NGINX KIC will be configured with a BIG-IP VS ConfigMap (AS3 type) to automatically drive the configuration of BIG-IP in order to expose NGINX KIC's pods to the ourside world.

## Preprare k8s storage to host Hackazon Web Content
Connect to infra-server via ssh and execute 

    sudo su -
    cd /usr/local/share/gv/k8s-udf-storage
    mkdir -p blog-apps/wordpress
    cd blog-apps/wordpress
    curl -O https://wordpress.org/latest.tar.gz
    tar xzf latest.tar.gz
    chown -R 999:999 wordpress

## Build the Wordpress on NGINX Unit Docker Container and push it to the local registry
We need to build the docker container starting from NGINX Unit and hosting worpress code; go to infra-server and clone the wordpress-k8s repository with NGINX Unit base:

   git clone https://github.com/tomminux/wordpress-k8s.git

and now build the docker container for Wordpress on NGINX Unit:

    cd ~/wordpress-k8s/docker-build
    docker build . -t registry.f5-udf.com:5000/wordpress:unit
    docker push registry.f5-udf.com:5000/wordpress:unit

WE are now ready to deploy the app in Kubernetes.

## Creating the Projetc and the Namespace for Hackazon

Anywhere on your computer, download YAML files for hackazon deployment:

    git clone https://github.com/tomminux/wordpress-k8s.git

From UDF, through the BIG-IP component, connect and login with admin user to the Rancher UI, click on k8s-udf kubernetes cluster and on "Projetcs/Namespaces" link. Add a project called "Blogging Platforms" (Add project -> "Bloggin Platforms" in the text field -> Create) and the click on the add Namespace button next to "Project: Hackazon". Put "blog-apps" in the Name field and click create.

Now click on the "Project: Blogging Platforms", Resources -> Workloads and select the "Import YAML" button. Select "Namespace: Import all resources into a specific namespace", Click on "Read from a File" and select the file "1.bigip-k8s-ctlr-deployment.yaml" from the just cloned repository in the "namespace-preparation" directory. Repeat the procedure for the "2.nginx-kic-cis.yaml" yaml file.

Repeat the procedure to import the "1.mysql.yaml" and "2-wordpress.yaml" in the main directory

## Checks

- In the Rancher UI, multiple pods will appear. 
- In BIG-IP TMUI, nginx-ingres VSes should appear under Virtual Servers -> blog-apps partition. They should be green and they should have a pool resource with 2 pool members, corresponding to the two pods running NGINX KIC for this Namespace.
- From win-jumphost, open chrome and try to connect to http://wordpress.f5-udf.com
