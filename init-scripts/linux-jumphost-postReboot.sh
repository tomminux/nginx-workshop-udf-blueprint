#!/bin/bash

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common xrdp xfce4 firefox

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

10.1.1.10 linux-jumphost
EOF'

sudo sh -c 'cat <<EOF > /etc/resolv.conf
search f5-udf.com
nameserver 10.1.1.4
nameserver 10.1.1.2
nameserver 8.8.8.8
EOF'

## ..:: Configuring XFCE4 Desktop Environment ::..

echo xfce4-session > /home/ubuntu/.xsession
sudo cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh-bak

sudo sh -c 'cat <<EOF > /etc/xrdp/startwm.sh
#!/bin/sh

if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG LANGUAGE
fi

startxfce4

EOF'

sudo systemctl enable xrdp
sudo systemctl restart xrdp
sudo systemctl status xrdp

## ..:: Google Chrome installation ::..

sudo sh -c 'cat <<EOF > /etc/apt/sources.list.d/google-chrome.list
deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main

EOF'
wget https://dl.google.com/linux/linux_signing_key.pub
sudo apt-key add linux_signing_key.pub
sudo apt update
sudo apt install google-chrome-stable

