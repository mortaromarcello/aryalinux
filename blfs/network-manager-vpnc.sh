#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:vpnc

URL=http://archive.ubuntu.com/ubuntu/pool/universe/n/network-manager-vpnc/network-manager-vpnc_0.9.10.0.orig.tar.xz

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

echo "network-manager-vpnc=>`date`" | sudo tee -a $INSTALLED_LIST
