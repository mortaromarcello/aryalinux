#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libjpeg6b_6b.orig:2

URL=http://archive.ubuntu.com/ubuntu/pool/universe/libj/libjpeg6b/libjpeg6b_6b2.orig.tar.gz

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

echo "libjpeg62=>`date`" | sudo tee -a $INSTALLED_LIST
