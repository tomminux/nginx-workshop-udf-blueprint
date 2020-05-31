#!/bin/bash

kubectl create secret generic bigip-login -n kube-system --from-literal=username=admin --from-literal=password=Default1234!
kubectl create serviceaccount k8s-bigip-ctlr -n kube-system

kubectl create -f 2.bigip-k8s-ctlr-deployment.yaml