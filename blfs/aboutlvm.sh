#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:postlfs





NAME="aboutlvm"



URL=
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
