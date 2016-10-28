#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:gstreamer.orig:0.10_0.10.36

PACKAGE_NAME="gstreamer-0.10"

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10/gstreamer0.10_0.10.36.orig.tar.bz2"
wget -nc $URL
wget -nc https://github.com/Metrological/buildroot/raw/master/package/gstreamer/gstreamer/gstreamer-01-bison3.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../gstreamer-01-bison3.patch
./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
