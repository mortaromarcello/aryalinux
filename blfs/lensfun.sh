#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:lensfun_.orig:0.3.2

URL=http://archive.ubuntu.com/ubuntu/pool/universe/l/lensfun/lensfun_0.3.2.orig.tar.gz

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
sudo rm -rf $DIRECTORY

echo "lensfun=>`date`" | sudo tee -a $INSTALLED_LIST
