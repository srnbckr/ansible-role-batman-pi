ansible-role-batman-pi
=========

This ansible role creates a mesh network based on the B.A.T.M.A.N.-adv protocol on a set of Raspberry Pi's.
It further installs a DHCP server on one of the nodes to provide dynamic IP addresses in the mesh.

Usage
------------
Install ansible via pip:

    pip install -r requirements.txt

On Ubuntu, also install sshpass to enable password usage in Ansible:

    sudo apt-get install sshpass

Adjust the inventory file and add one of the nodes to the `dhcp` group , i.e.

    [dhcp]
    pi-1 ansible_host="192.168.21.153" ansible_user="pi" ansible_password="raspberry"

    [clients]
    pi-2 ansible_host="192.168.21.123" ansible_user="pi" ansible_password="raspberry"
    pi-3 ansible_host="192.168.21.124" ansible_user="pi" ansible_password="raspberry"


Adjust variables in `defaults/main.yml` and run the playbook with:

    ansible-playbook -i inventory install-mesh.yml

