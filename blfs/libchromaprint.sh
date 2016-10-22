#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:chromaprint_.orig:1.3

#REQ:ffmpeg

URL=http://archive.ubuntu.com/ubuntu/pool/universe/c/chromaprint/chromaprint_1.3.orig.tar.gz

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

echo "libchromaprint=>`date`" | sudo tee -a $INSTALLED_LIST
