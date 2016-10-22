#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:bumblebee_.orig:3.2.1

#REQ:libbsd
#REQ:bbswitch

URL=http://archive.ubuntu.com/ubuntu/pool/universe/b/bumblebee/bumblebee_3.2.1.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  --sysconfdir=/etc --localstatedir=/var &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "bumblebee=>`date`" | sudo tee -a $INSTALLED_LIST
