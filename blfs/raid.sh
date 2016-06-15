#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

/sbin/mdadm -Cv /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
/sbin/mdadm -Cv /dev/md1 --level=1 --raid-devices=2 /dev/sda2 /dev/sdb2
/sbin/mdadm -Cv /dev/md3 --level=0 --raid-devices=2 /dev/sdc1 /dev/sdd1
/sbin/mdadm -Cv /dev/md2 --level=5 --raid-devices=4 \
        /dev/sda4 /dev/sdb4 /dev/sdc2 /dev/sdd2


cd $SOURCE_DIR

echo "raid=>`date`" | sudo tee -a $INSTALLED_LIST

