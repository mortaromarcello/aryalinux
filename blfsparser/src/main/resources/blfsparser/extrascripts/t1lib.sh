#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://fossies.org/linux/misc/t1lib-5.1.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -c $URL
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`" without_doc

sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "t1lib=>`date`" | sudo tee -a $INSTALLED_LIST
