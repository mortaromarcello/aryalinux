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


sed '1d;/SYMLINK.*cdrom/ a\
KERNEL=="sr0", ENV{ID_CDROM_DVD}=="1", SYMLINK+="dvd", OPTIONS+="link_priority=-100"' \
/lib/udev/rules.d/60-cdrom_id.rules > /etc/udev/rules.d/60-cdrom_id.rules


cd $SOURCE_DIR

echo "devices=>`date`" | sudo tee -a $INSTALLED_LIST

