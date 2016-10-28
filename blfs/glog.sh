#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:v:0.3.4

PACKAGE_NAME="glog"
URL=https://github.com/google/glog/archive/v0.3.4.tar.gz

cd $SOURCE_DIR
wget -nc $URL -O glog-0.3.4.tar.gz

TARBALL=glog-0.3.4.tar.gz
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
