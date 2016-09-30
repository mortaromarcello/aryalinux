#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:openconnect

URL=http://archive.ubuntu.com/ubuntu/pool/universe/n/network-manager-openconnect/network-manager-openconnect_1.0.2.orig.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-gnome &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "network-manager-openconnect=>`date`" | sudo tee -a $INSTALLED_LIST
