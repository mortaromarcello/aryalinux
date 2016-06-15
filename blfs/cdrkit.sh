#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:cdrkit:1.1.11

cd $SOURCE_DIR

URL="https://launchpad.net/ubuntu/+archive/primary/+files/cdrkit_1.1.11.orig.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "cdrkit=>`date`" | sudo tee -a $INSTALLED_LIST
