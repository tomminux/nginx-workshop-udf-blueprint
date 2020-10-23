#!/bin/bash

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt-add-repository "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main"
DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install ansible -y

## ..:: Installing dnsmasq ::..
sudo apt install dnsmasq -y
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.conf
sudo systemctl restart dnsmasq
