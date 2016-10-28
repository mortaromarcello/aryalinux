#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:gst-plugins-base.orig:0.10_0.10.36

PACKAGE_NAME="gstreamer-0.10-plugins-base"

#REQ:gstreamer-0.10

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/g/gst-plugins-base0.10/gst-plugins-base0.10_0.10.36.orig.tar.bz2"
wget -nc $URL
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/2016.08/gst-plugins-base-0.10.36-gcc_4_9_0_i686-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

if [ "`uname -m`" != "x86_64" ]
then
	patch -Np1 -i ../gst-plugins-base-0.10.36-gcc_4_9_0_i686-1.patch
fi

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$PACKAGE_NAME=>`date`" | sudo tee -a $INSTALLED_LIST
