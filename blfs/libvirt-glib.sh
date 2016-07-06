#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libvirt-glib:0.2.3

cd $SOURCE_DIR

URL="https://libvirt.org/sources/glib/libvirt-glib-0.2.3.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -rf check

echo "libvirt-glib=>`date`" | sudo tee -a $INSTALLED_LIST
