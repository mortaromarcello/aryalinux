#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:jq:1.5

cd $SOURCE_DIR

URL="https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "jq=>`date`" | sudo tee -a $INSTALLED_LIST

