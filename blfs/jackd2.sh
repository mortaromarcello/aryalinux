#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:jackd2_1.9.10+20150825git1ed50c~dfsg.orig:92

#REQ:jack2

URL=http://archive.ubuntu.com/ubuntu/pool/main/j/jackd2/jackd2_1.9.10+20150825git1ed50c92~dfsg.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./waf configure
./waf
sudo ./waf install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "jackd2=>`date`" | sudo tee -a $INSTALLED_LIST
