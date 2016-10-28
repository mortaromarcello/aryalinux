#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:gstreamer0.10-ffmpeg.orig:_0.10.13

PACKAGE_NAME="gstreamer-0.10-ffmpeg"

#REQ:gstreamer-0.10

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10-ffmpeg/gstreamer0.10-ffmpeg_0.10.13.orig.tar.bz2"
wget -nc $URL
wget -nc https://raw.githubusercontent.com/maximeh/buildroot/master/package/gstreamer/gst-ffmpeg/0001-gcc47.patch
wget -nc https://raw.githubusercontent.com/maximeh/buildroot/master/package/gstreamer/gst-ffmpeg/0002-arm-avoid-using-the-movw-instruction.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../0001-gcc47.patch
patch -Np1 -i ../0002-arm-avoid-using-the-movw-instruction.patch

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
