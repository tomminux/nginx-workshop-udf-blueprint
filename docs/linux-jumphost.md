# ..:: Linux Jumphost Configuration ::..

Create a Ubuntu 18.04 Server with 2 vCPU and 4GB of RAM, and connect it to Internal and External networks

    mgmt      eth0    10.1.1.10
    internal  eth1    10.1.10.10
    external  eth2    10.1.20.10
    
Start it.

Once started, connect over SSH and:

    git clone https://github.com/tomminux/nginx-workshop-udf-blueprint.git
    cd nginx-workshop-udf-blueprint
    bash init-scripts/linux-jumphost.sh
    
It will reboot at the end of the script execution. Re-connect over SSH and:

    cd nginx-workshop-udf-blueprint
    bash init-scripts/linux-jumphost-postReboot.sh
