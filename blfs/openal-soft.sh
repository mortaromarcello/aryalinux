#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:openal-soft_.orig:1.17.2

URL=http://archive.ubuntu.com/ubuntu/pool/universe/o/openal-soft/openal-soft_1.17.2.orig.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr . &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "openal-soft=>`date`" | sudo tee -a $INSTALLED_LIST
