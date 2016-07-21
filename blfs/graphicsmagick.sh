#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

URL=https://sourceforge.net/projects/graphicsmagick/files/graphicsmagick/1.3.24/GraphicsMagick-1.3.24.tar.xz/download

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-quantum-depth=16 --enable-shared --without-lcms &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "graphicsmagick=>`date`" | sudo tee -a $INSTALLED_LIST
