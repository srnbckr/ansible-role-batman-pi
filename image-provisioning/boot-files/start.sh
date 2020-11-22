#!/bin/sh

# source mesh config
. /boot/meshconfig

if [ -f /boot/initial ]; then
    
    # check if hostname file exists
    if [ -f /boot/hostname ]; then
        echo "Setting hostname"
        cp /boot/hostname /etc/hostname
    fi

    if [ -f /boot/wlan0 ]; then
        echo "Copying wlan interfaces"
        cp /boot/wlan0 /etc/network/interfaces.d/wlan0
    fi

    if [ -f /boot/dnsmasq ]; then
        echo "Installing and configuring dnsmasq DHCP server"
        sudo apt-get update && sudo apt-get install -y dnsmasq
cat << EOF > /etc/dnsmasq.conf
port=53
domain-needed
bogus-priv
strict-order
server=$EXTERNAL_DNS
interface=bat0
dhcp-range=$DHCP_RANGE
EOF
    fi

    if [ -f /boot/batman.sh ]; then
        echo "Setting up B.A.T.M.A.N.-adv mesh"
        cp /boot/batman.sh /home/pi/batman.sh
    fi

    # remove init file
    rm /boot/initial
    
    # reboot to set hostname
    reboot
fi

if [ -f /home/pi/batman.sh ]; then
    if [ -f /boot/dnsmasq ]; then
        /home/pi/batman.sh gateway &
    else
        /home/pi/batman.sh client &
    fi
fi
    
