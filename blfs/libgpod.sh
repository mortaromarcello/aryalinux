#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libplist

URL=http://archive.ubuntu.com/ubuntu/pool/main/libg/libgpod/libgpod_0.8.3.orig.tar.bz2

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

echo "libgpod=>`date`" | sudo tee -a $INSTALLED_LIST
