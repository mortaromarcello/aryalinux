#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:postlfs

whoami > /tmp/currentuser





NAME="devices"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mount --bind / /mnt
cp -a /dev/* /mnt/dev
rm /etc/rc.d/rcS.d/{S10udev,S50udev_retry}
umount /mnt


sed '1d;/SYMLINK.*cdrom/ a\
KERNEL=="sr0", ENV{ID_CDROM_DVD}=="1", SYMLINK+="dvd", OPTIONS+="link_priority=-100"' \
/lib/udev/rules.d/60-cdrom_id.rules > /etc/udev/rules.d/60-cdrom_id.rules




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
