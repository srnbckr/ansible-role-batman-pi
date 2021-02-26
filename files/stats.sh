#!/bin/sh

FREQUENCY=5
BATDEVICE=bat0
PROMFILE=/var/lib/node_exporter/textfiles/batadv-stats.prom


while [ true ];
do
    /sbin/ethtool -S bat0 | awk -v batdev=$BATDEVICE '
        /^     .*:/ {
          gsub(":", "");
          print "batman_" $1 "{batdev=\"" batdev "\"} " $2
        }
    ' > $PROMFILE
    sleep $FREQUENCY
done > $PROMFILE