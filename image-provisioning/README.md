README
=======

This files can be used to provision Raspberry Pis with a custom Raspberry Pi OS image and automatically configure the mesh network on first boot.

Usage
======
Download the custom Raspberry Pi image (i.e. bdr-raspios.img) and place it somewhere on your local PC.

Copy the image to the respective SDCard, i.e. with the write-image.sh script: In the following example, the SDCard is located at /dev/mmcblk0.

    ./write-image.sh mmcblk0 bdr-raspios.img


Adjust the following files:

## meshconfig

    # Interface used for batman
    WIFI_INTERFACE=wlan0
    # Interface with internet connectivity, used on gateway nodes
    INET_NETWORK=eth0
    # DHCP range
    DHCP_RANGE="10.240.1.10,10.240.1.100,6h"
    GATEWAY_IP="10.240.1.1/24"
    # dns server
    EXTERNAL_DNS="8.8.8.8"


## hostname
Set the hostname of the node


After the image was written, remount the SDCard and copy the following files to the boot partition on the SDCard:
  * boot-files/batman.sh
  * boot-files/hostname
  * boot-files/initial
  * boot-files/meshconfig
  * boot-files/ssh
  * boot-files/start.sh
  * boot-files/wlan0

In case the node should act as the DHCP server, also copy *boot-files/dnsmasq* to the boot partition.

Unmount the SDcard.

