#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libqjson0

URL=http://archive.ubuntu.com/ubuntu/pool/universe/libm/libmygpo-qt/libmygpo-qt_1.0.9~git20151122.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "libmygpo-qt1=>`date`" | sudo tee -a $INSTALLED_LIST
