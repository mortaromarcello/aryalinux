#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:plymouth:0.9.2

cd $SOURCE_DIR

URL="https://www.freedesktop.org/software/plymouth/releases/plymouth-0.9.2.tar.bz2"
wget -nc $URL
wget -nc http://aryalinux.org/releases/2016.04/arya-plymouth-theme.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --enable-systemd-integration --enable-static --disable-pango --disable-gtk &&
make "-j`nproc`"

sudo make install
echo 'add_dracutmodules+="plymouth"' | sudo tee -a /usr/etc/dracut.conf

cd $SOURCE_DIR

sudo tar xf arya-plymouth-theme.tar.gz -C /usr/share/plymouth/themes
sudo plymouth-set-default-theme arya
sudo dracut -f /boot/initrd.img-`ls /boot/vmlinuz-4.6.2 | sed "s@/boot/vmlinuz-@@g"` `ls /lib/modules`

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "plymouth=>`date`" | sudo tee -a $INSTALLED_LIST
