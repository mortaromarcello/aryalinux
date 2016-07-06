#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libcacard:2.5.2

cd $SOURCE_DIR

URL="http://www.spice-space.org/download/libcacard/libcacard-2.5.2.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libcacard=>`date`" | sudo tee -a $INSTALLED_LIST
