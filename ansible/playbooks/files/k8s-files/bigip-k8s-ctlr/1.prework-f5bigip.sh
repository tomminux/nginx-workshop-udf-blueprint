#!/bin/bash

kubectl create secret generic bigip-login -n kube-system --from-literal=username=admin --from-literal=password=Default1234!
kubectl create serviceaccount k8s-bigip-ctlr -n kube-system
kubectl create clusterrolebinding k8s-bigip-ctlr-clusteradmin --clusterrole=cluster-admin --serviceaccount=kube-system:k8s-bigip-ctlr

### kubectl create -f 2.bigip-k8s-ctlr-deployment.yaml
