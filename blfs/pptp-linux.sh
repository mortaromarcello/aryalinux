#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:ppp

URL=http://archive.ubuntu.com/ubuntu/pool/main/p/pptp-linux/pptp-linux_1.8.0.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

make
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "pptp-linux=>`date`" | sudo tee -a $INSTALLED_LIST
