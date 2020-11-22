#!/bin/bash

IMG_FILE=$1
SECTOR_OFFSET=$(sudo fdisk -l $IMG_FILE | awk '$7 == "Linux" { print $2 }')
BYTE_OFFSET=$(expr 512 \* $SECTOR_OFFSET)

IMG_DIR=$(basename "$IMG_FILE")
IMG_DIR="${IMG_DIR%.*}"

echo Mounting at /mnt/$IMG_DIR
echo "Offset : $BYTE_OFFSET"
sudo mkdir -p /mnt/$IMG_DIR
sudo mount -o loop,offset=$BYTE_OFFSET $IMG_FILE /mnt/$IMG_DIR