#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






pvcreate /dev/sda4 /dev/sdb2

vgcreate lfs-lvm /dev/sda4  /dev/sdb2

lvcreate --name mysql --size 2500G lfs-lvm
lvcreate --name home  --size  500G lfs-lvm

mkfs -t ext4 /dev/lfs-lvm/home
mkfs -t jfs  /dev/lfs-lvm/mysql
mount /dev/lfs-lvm/home /home
mkdir -p /srv/mysql
mount /dev/lfs-lvm/mysql /srv/mysql


 
cd $SOURCE_DIR
 
echo "aboutlvm=>`date`" | sudo tee -a $INSTALLED_LIST