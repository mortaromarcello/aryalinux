#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:fftw:3.3.4

URL=http://www.fftw.org/fftw-3.3.4.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

CFLAGS="$CFLAGS -fPIC" ./configure --prefix=/usr --enable-float &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "libfftw3=>`date`" | sudo tee -a $INSTALLED_LIST
