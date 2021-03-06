#!/bin/bash

sudo ssh-keygen -b 2048 -t rsa
sudo sh -c 'cp /root/.ssh/id_rsa* /home/ubuntu/.ssh/.'
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id*
sudo sh -c 'cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
DEBIAN_FRONTEND=noninteractive
sudo apt update 
sudo apt upgrade -y
sudo apt autoremove

sudo sh -c 'echo "infra-server" > /etc/hostname'
sudo touch /etc/rc.local
sudo chmod 755 /etc/rc.local

sudo sh -c 'cat <<EOF > /etc/rc.local
#!/bin/bash
ifconfig ens4 10.1.20.20/24 up
ifconfig ens4:25 10.1.20.25/24 up
ifconfig ens4:30 10.1.20.30/24 up
ifconfig ens4:35 10.1.20.35/24 up
ifconfig ens4:40 10.1.20.40/24 up
#ifconfig ens4:50 10.1.20.50/24 up
ifconfig ens4:80 10.1.20.80/24 up

## ..:: Max Map Count for VM when runnign ELK in a Docker container ::..
sysctl -w vm.max_map_count=262144

exit 0
EOF'

sudo reboot
