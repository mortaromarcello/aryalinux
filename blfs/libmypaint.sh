#!/bin/bash

set -e
set +h

#VER:libmypaint:1.3.0

. /etc/alps/alps.conf

URL=https://github.com/mypaint/libmypaint/releases/download/v1.3.0-beta.1/libmypaint-1.3.0-beta.1.tar.xz

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

echo "libmypaint=>`date`" | sudo tee -a $INSTALLED_LIST
