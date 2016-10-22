#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libjpeg8_8d.orig:1

URL=http://http.debian.net/debian/pool/main/libj/libjpeg8/libjpeg8_8d1.orig.tar.gz

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

echo "libjpeg8=>`date`" | sudo tee -a $INSTALLED_LIST
