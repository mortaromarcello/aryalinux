#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="fftw"
VERSION="3.3.4"

URL=http://www.fftw.org/fftw-3.3.4.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

CFLAGS="$CFLAGS -fPIC" ./configure --prefix=/usr --enable-double --enable-shared --enable-openmp --enable-threads
make "-j`nproc`"
sudo make install
make clean
CFLAGS="$CFLAGS -fPIC" ./configure --prefix=/usr --enable-float --enable-shared --enable-openmp --enable-threads
make "-j`nproc`"
sudo make install
make clean
CFLAGS="$CFLAGS -fPIC" ./configure --prefix=/usr --enable-long-double --enable-shared --enable-openmp --enable-threads
make "-j`nproc`"
sudo make install
make clean

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
