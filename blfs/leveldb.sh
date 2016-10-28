#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:leveldb_.orig:1.18

PACKAGE_NAME="leveldb"

#REQ:snappy

URL=http://archive.ubuntu.com/ubuntu/pool/main/l/leveldb/leveldb_1.18.orig.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

make
sudo mkdir -pv /usr/include/leveldb
sudo install include/leveldb/*.h /usr/include/leveldb
sudo cp -a ./libleveldb.so* /usr/lib/

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
