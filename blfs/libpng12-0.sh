#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

URL=http://http.debian.net/debian/pool/main/libp/libpng/libpng_1.2.50.orig.tar.xz

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
rm -rf $DIRECTORY

echo "libpng12-0=>`date`" | sudo tee -a $INSTALLED_LIST
