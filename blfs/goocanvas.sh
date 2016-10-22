#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:goocanvas_.orig:1.0.0

URL=http://archive.ubuntu.com/ubuntu/pool/universe/g/goocanvas/goocanvas_1.0.0.orig.tar.gz

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

echo "goocanvas=>`date`" | sudo tee -a $INSTALLED_LIST
