#!/bin/sh

#WIFI_INTERFACE=wlan0
#INET_NETWORK=eth0
DHCP_RANGE=10.240.1.10,10.240.1.100,255.255.255.0,6h
GATEWAY_IP=10.240.1.1/24

# source config file
. /boot/meshconfig

install_batctl () {
  sudo apt-get install -y batctl
  echo 'batman-adv' | sudo tee --append /etc/modules
  echo 'denyinterfaces wlan0' | sudo tee --append /etc/dhcpcd.conf
}

get_mac_addr() {
    echo $(cat /sys/class/net/$1/address)
}

mac_to_ipv6_ll() {
    IFS=':'; set $1; unset IFS
    echo "fe80::$(printf %02x $((0x$1 ^ 2)))$2:${3}ff:fe$4:$5$6"
}

install_dnsmasq() {
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
    sudo systemctl restart dnsmasq.service
}


gateway () {
    sudo rfkill unblock wifi
    sudo modprobe batman-adv
    sudo batctl if add $WIFI_INTERFACE
    sudo batctl gw_mode server
    sudo sysctl -w net.ipv4.ip_forward=1
    # This sets up routing between the mesh network (bat0) and the internet network (eth0)
    sudo iptables -t nat -A POSTROUTING -o $INET_NETWORK -j MASQUERADE
    sudo iptables -A FORWARD -i $INET_NETWORK -o bat0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i bat0 -o $INET_NETWORK -j ACCEPT

    sudo ifconfig $WIFI_INTERFACE up
    mac_addr=$(get_mac_addr $WIFI_INTERFACE)
    ipv6_ll=$(mac_to_ipv6_ll $mac_addr)

    sudo ifconfig bat0 up
    sudo ip link set bat0 address $mac_addr                                                                                                                                                                
    sudo ip -6 addr add $ipv6_ll/64 dev bat0   
    sudo ifconfig bat0 $GATEWAY_IP
    sudo systemctl restart dnsmasq.service
}

client () {
    sudo rfkill unblock wifi
    sudo modprobe batman-adv
    sudo batctl if add $WIFI_INTERFACE
    sudo ifconfig bat0 mtu 1468
    sudo batctl gw_mode client 

    sudo ifconfig $WIFI_INTERFACE up
    mac_addr=$(get_mac_addr $WIFI_INTERFACE)
    ipv6_ll=$(mac_to_ipv6_ll $mac_addr)
    sudo ifconfig bat0 up
    sudo ip link set bat0 address $mac_addr                                                                                                                                                                
    sudo ip -6 addr add $ipv6_ll/64 dev bat0
}

if ! [ -x "$(command -v batctl)" ]; then
  install_batctl
fi

if [ -n "$1" ]; then
  $1
else
  echo "Please run with either <client/gatway>"
  exit 1
fi