#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:hardinfo:0.5.1

URL=http://archive.ubuntu.com/ubuntu/pool/universe/h/hardinfo/hardinfo_0.5.1.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
rm -rf makefile.patch
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/2016.08/makefile.patch
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --build=aryalinux &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "hardinfo=>`date`" | sudo tee -a $INSTALLED_LIST
