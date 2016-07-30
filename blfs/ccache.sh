#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:ccache:3.2.4

cd $SOURCE_DIR

URL="https://www.samba.org/ftp/ccache/ccache-3.2.4.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "ccache=>`date`" | sudo tee -a $INSTALLED_LIST
