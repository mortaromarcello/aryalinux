#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:icoutils_.orig:0.31.0

#REQ:perl-modules#perl-lwp

URL=http://archive.ubuntu.com/ubuntu/pool/universe/i/icoutils/icoutils_0.31.0.orig.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "icoutils=>`date`" | sudo tee -a $INSTALLED_LIST