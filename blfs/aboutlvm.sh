#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

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

