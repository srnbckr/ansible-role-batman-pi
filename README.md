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

Install ansible-galaxy dependencies

    ansible-galaxy install -r requirements.yaml

Adjust the inventory file and add one of the nodes to the `dhcp` group , i.e.

    [dhcp]
    pi-1 ansible_host="192.168.21.153" ansible_user="pi" ansible_password="raspberry"

    [clients]
    pi-2 ansible_host="192.168.21.123" ansible_user="pi" ansible_password="raspberry"
    pi-3 ansible_host="192.168.21.124" ansible_user="pi" ansible_password="raspberry"


Adjust variables in `defaults/main.yml` and run the playbook with:

    ansible-playbook -i inventory install-mesh.yml

In case the mesh IPs should be configured manually, leave the `dhcp` group empty, set `manual_ip: "true"` in `defaults/main.yml` and provide a `mesh_ip` variable for each node in the infrastructure, i.e.:

    [dhcp]

    [clients]
    pi-2 ansible_host="192.168.21.123" ansible_user="pi" ansible_password="raspberry" mesh_ip="10.1.1.1"
    pi-3 ansible_host="192.168.21.124" ansible_user="pi" ansible_password="raspberry" mesh_ip="10.1.1.2"

Node-exporter
------------
[Node-exporter](https://github.com/prometheus/node_exporter) is installed on every node and provides system metrics at `http://<NODE-IP>:9100/metrics`.
In addition, a custom exporter is configured to also provide statistics of the underlying mesh network, i.e.
    
    # mesh interface statistics
    batman_tx{batdev="bat0"} 26598906
    batman_tx_bytes{batdev="bat0"} 10901024476
    batman_tx_dropped{batdev="bat0"} 1374
    batman_rx{batdev="bat0"} 43662337
    batman_rx_bytes{batdev="bat0"} 8647520132
    batman_forward{batdev="bat0"} 9005
    batman_forward_bytes{batdev="bat0"} 1186985
    batman_mgmt_tx{batdev="bat0"} 2441845
    batman_mgmt_tx_bytes{batdev="bat0"} 209268554
    batman_mgmt_rx{batdev="bat0"} 12848102
    batman_mgmt_rx_bytes{batdev="bat0"} 1054782600
    batman_frag_tx{batdev="bat0"} 1884876738
    batman_frag_tx_bytes{batdev="bat0"} 1464558127462
    batman_frag_rx{batdev="bat0"} 1567538519
    batman_frag_rx_bytes{batdev="bat0"} 1196031896478
    batman_frag_fwd{batdev="bat0"} 54060
    batman_frag_fwd_bytes{batdev="bat0"} 42004620
    batman_tt_request_tx{batdev="bat0"} 3622
    batman_tt_request_rx{batdev="bat0"} 115
    batman_tt_response_tx{batdev="bat0"} 115
    batman_tt_response_rx{batdev="bat0"} 337
    batman_tt_roam_adv_tx{batdev="bat0"} 0
    batman_tt_roam_adv_rx{batdev="bat0"} 0
    batman_dat_get_tx{batdev="bat0"} 143065
    batman_dat_get_rx{batdev="bat0"} 6463
    batman_dat_put_tx{batdev="bat0"} 24
    batman_dat_put_rx{batdev="bat0"} 0
    batman_dat_cached_reply_tx{batdev="bat0"} 728
    batman_nc_code{batdev="bat0"} 0
    batman_nc_code_bytes{batdev="bat0"} 0
    batman_nc_recode{batdev="bat0"} 0
    batman_nc_recode_bytes{batdev="bat0"} 0
    batman_nc_buffer{batdev="bat0"} 0
    batman_nc_decode{batdev="bat0"} 0
    batman_nc_decode_bytes{batdev="bat0"} 0
    batman_nc_decode_failed{batdev="bat0"} 0
    batman_nc_sniffed{batdev="bat0"} 0

    # direct neighbors in the mesh network
    # tp = throughput
    batman_neighbor_tp{neighbor="fa:16:3e:fb:26:c6"} 164.83
    batman_neighbor_latency{neighbor="fa:16:3e:fb:26:c6"} 0.217
    batman_neighbor_tp{neighbor="fa:16:3e:40:c7:76"} 59.43
    batman_neighbor_latency{neighbor="fa:16:3e:40:c7:76"} 0.686
    batman_neighbor_tp{neighbor="fa:16:3e:b9:ac:92"} 87.41
    batman_neighbor_latency{neighbor="fa:16:3e:b9:ac:92"} 0.229
    batman_neighbor_tp{neighbor="fa:16:3e:db:e6:61"} 0
    batman_neighbor_latency{neighbor="fa:16:3e:db:e6:61"} 0.465
    batman_neighbor_tp{neighbor="fa:16:3e:87:53:fc"} 23.59
    batman_neighbor_latency{neighbor="fa:16:3e:87:53:fc"} 21.394

