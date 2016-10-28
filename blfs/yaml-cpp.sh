#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:yaml-cpp:0.5.3

PACKAGE_NAME="yaml-cpp"

URL=https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.5.3.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

CFLAGS=-fPIC cmake -DCMAKE_INSTALL_PREFIX=/usr . &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
