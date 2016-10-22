#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libvirt:2.0.0

#REQ:yajl

cd $SOURCE_DIR

URL="http://libvirt.org/sources/libvirt-2.0.0.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libvirt=>`date`" | sudo tee -a $INSTALLED_LIST
