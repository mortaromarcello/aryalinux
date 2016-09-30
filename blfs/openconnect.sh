#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:openconnect_.orig:7.06


URL=http://archive.ubuntu.com/ubuntu/pool/universe/o/openconnect/openconnect_7.06.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "openconnect=>`date`" | sudo tee -a $INSTALLED_LIST
