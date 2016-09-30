#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:goocanvas

URL=http://archive.ubuntu.com/ubuntu/pool/universe/p/pygoocanvas/pygoocanvas_0.14.1.orig.tar.gz

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

echo "pygoocanvas=>`date`" | sudo tee -a $INSTALLED_LIST
