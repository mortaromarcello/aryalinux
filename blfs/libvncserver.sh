#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libvncserver_+dfsg.orig:0.9.10

URL=http://archive.ubuntu.com/ubuntu/pool/main/libv/libvncserver/libvncserver_0.9.10+dfsg.orig.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "libvncserver=>`date`" | sudo tee -a $INSTALLED_LIST
