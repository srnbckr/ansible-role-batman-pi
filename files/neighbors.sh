#!/bin/bash

FREQUENCY=60
TP_TIMEOUT=500
PING_COUNT=3
PROMFILE=/var/lib/node_exporter/textfiles/batctl-neighbors.prom


run_benchmark() {
    for nb in $(batctl n -H | awk '{print $2}'); do
            while [ -z $tp ] || [ -z $nb ]; do
                ip=$(get_ip $nb)
                tp=$(batctl tp $nb -t $TP_TIMEOUT | awk '{print $2}' | tail -1)
                #avg_ping=$(ping -c $PING_COUNT $ip | tail -1 | awk '{ split($4,a,"/"); print a[2]}')
                # use this for "real" wifi mesh metrics
                avg_ping=$(batctl p $nb -c $PING_COUNT -T | tail -1 | awk '{ split($4,a,"/"); print a[2]}')
            done
            if [[ -n "${tp// }" ]] && [[ -n "${avg_ping// }" ]]; then
                echo "batman_neighbor_tp{neighbor=\"$nb\"} $tp"
                echo "batman_neighbor_latency{neighbor=\"$nb\"} $avg_ping"
            fi
            unset tp
            unset avg_ping
    done
} > $PROMFILE.tmp

while [ true ];
do
    run_benchmark
    mv $PROMFILE.tmp $PROMFILE
    sleep $FREQUENCY
done
