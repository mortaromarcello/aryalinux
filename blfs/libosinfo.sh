#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libosinfo:0.3.1

#REQ:check

cd $SOURCE_DIR

URL="https://fedorahosted.org/releases/l/i/libosinfo/libosinfo-0.3.1.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libosinfo=>`date`" | sudo tee -a $INSTALLED_LIST
