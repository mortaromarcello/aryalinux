#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:check:0.10.0

cd $SOURCE_DIR

URL="http://archive.ubuntu.com/ubuntu/pool/universe/c/check/check_0.10.0.orig.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -rf check

echo "check=>`date`" | sudo tee -a $INSTALLED_LIST
