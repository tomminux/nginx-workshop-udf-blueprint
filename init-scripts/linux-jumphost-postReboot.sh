#!/bin/bash

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

## ..:: Installing dnsmasq ::..
sudo rm /etc/resolv.conf
sudo sh -c 'cat <<EOF > /etc/resolv.conf
search f5-udf.com
nameserver 10.1.1.4
nameserver 10.1.1.2
nameserver 8.8.8.8
EOF'

