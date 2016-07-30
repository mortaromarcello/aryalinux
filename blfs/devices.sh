#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

mount --bind / /mnt
cp -a /dev/* /mnt/dev
rm /etc/rc.d/rcS.d/{S10udev,S50udev_retry}
umount /mnt


cd $SOURCE_DIR

echo "devices=>`date`" | sudo tee -a $INSTALLED_LIST

