#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libspnav_.orig:0.2.3

URL=http://archive.ubuntu.com/ubuntu/pool/universe/libs/libspnav/libspnav_0.2.3.orig.tar.gz

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

echo "libspnav=>`date`" | sudo tee -a $INSTALLED_LIST
