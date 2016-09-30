#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cairo

URL=http://archive.ubuntu.com/ubuntu/pool/universe/f/frei0r/frei0r_1.4.orig.tar.gz

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

echo "frei0r-plugins=>`date`" | sudo tee -a $INSTALLED_LIST
