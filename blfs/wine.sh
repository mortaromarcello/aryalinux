#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#VER:wine:1.8.3

cd $SOURCE_DIR

URL="http://dl.winehq.org/wine/source/1.8/wine-1.8.3.tar.bz2"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --enable-win64 &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "wine=>`date`" | sudo tee -a $INSTALLED_LIST
