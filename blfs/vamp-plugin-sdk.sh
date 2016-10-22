#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:vamp-plugin-sdk:2.6

cd $SOURCE_DIR

URL="https://code.soundsoftware.ac.uk/attachments/download/1520/vamp-plugin-sdk-2.6.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "vamp-plugin-sdk=>`date`" | sudo tee -a $INSTALLED_LIST
