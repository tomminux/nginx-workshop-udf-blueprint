#!/bin/bash

DEBIAN_FRONTEND=noninteractive
sudo apt update 
sudo apt upgrade -y
sudo apt autoremove

sudo sh -c 'echo "rancher-server" > /etc/hostname'
sudo touch /etc/rc.local
sudo chmod 755 /etc/rc.local

sudo sh -c 'cat <<EOF > /etc/rc.local
#!/bin/bash
ifconfig ens4 10.1.10.50/24 up
exit 0
EOF'

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

## ..:: Setting DNS Resolution for this UDF Deployment ::..
sudo rm /etc/resolv.conf

sudo sh -c 'cat <<EOF > /etc/hosts
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

10.1.1.11 rancher-server

EOF'

sudo sh -c 'cat <<EOF > /etc/resolv.conf
search f5-udf.com
nameserver 10.1.1.4
nameserver 10.1.1.2
nameserver 8.8.8.8
EOF'

## ..:: Installing Docker ::..

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install docker-ce -y
sudo systemctl enable docker
sudo systemctl restart docker
sudo usermod -aG docker ubuntu

# Prepariing dockerhost-storage directory
mkdir -p dockerhost-storage/f5Rancher

cat <<EOF > startDockerContainers.sh
#!/bin/bash

docker run -d \
  --restart=always \
  --name f5Rancher \
  -p 10.1.20.50:80:80 -p 10.1.20.50:443:443 \
  -v ~/dockerhost-storage/rancher:/var/lib/rancher \
  --privileged \
  rancher/rancher:latest
EOF

chmod 755 startDockerContainers.sh

sudo reboot
