#!/bin/bash

DEBIAN_FRONTEND=noninteractive
sudo apt update 
sudo apt upgrade -y
sudo apt autoremove

sudo sh -c 'echo "linux-jumphost" > /etc/hostname'
sudo touch /etc/rc.local
sudo chmod 755 /etc/rc.local

sudo sh -c 'cat <<EOF > /etc/rc.local
#!/bin/bash

ifconfig eth1 10.1.10.10/24 up
ifconfig eth2 10.1.20.10/24 up

exit 0
EOF'

sudo reboot
