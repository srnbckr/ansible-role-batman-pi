#!/bin/bash

SDCARD=$1
IMAGE=$2
# write to sdcard
sudo dd bs=4M if=$IMAGE of=/dev/$SDCARD conv=fsync status=progress