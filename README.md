# NGINX Workshop - Blueprint 
    
## Introduction

This repository contains everyting needed to use the F5 UDF Bluprint named "Base Environment for NGINX Workshop". In here you'll find the documentation to build the bluprint from scratch, the [blueprint description](https://github.com/tomminux/nginx-workshop-udf-blueprint/blob/master/blueprint-description.txt), some documents on how to drive Demos with this specific environemnt and all the files needed.

## Organization

- [ansibile](https://github.com/tomminux/nginx-workshop-udf-blueprint/tree/master/ansible) directory contains every playbook needed to rebuild the environment from scratch
- [arcadia-on-unit](https://github.com/tomminux/nginx-workshop-udf-blueprint/tree/master/arcadia-on-unit) contains the necessary files to rebuild docker containers for the Arcadia Finance use case using the NGINX Unit Applilcation Server
- [docs](https://github.com/tomminux/nginx-workshop-udf-blueprint/tree/master/docs) contains all the documentation files
- [init-scripts](https://github.com/tomminux/nginx-workshop-udf-blueprint/tree/master/init-scripts) contains scripts to be run on the infra-server as prework before Ansible
- [The Postman NGINX Controller Collection](https://github.com/tomminux/nginx-workshop-udf-blueprint/blob/master/postman-ncontroller-collection.yaml)

## Documentation

- [How to build the blueprint from scratch](https://github.com/tomminux/nginx-workshop-udf-blueprint/blob/master/docs/how-to-build-the-blueprint.md)
- [DEMO: How to deploy Hackazon Vulnerable Web App in Kubernetes with NGINX KIC and F5 CIS](https://github.com/tomminux/nginx-workshop-udf-blueprint/blob/master/docs/kic-cis-use-case.md)