#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

PACKAGE_NAME="mutagen"

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/main/m/mutagen/mutagen_1.30.orig.tar.gz"
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr
make
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
