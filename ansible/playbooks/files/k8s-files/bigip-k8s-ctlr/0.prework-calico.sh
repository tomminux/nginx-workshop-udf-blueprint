#!/bin/bash

calicoctl create -f calico-config.yaml
calicoctl create -f calico-add-bigip.yaml
