#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

wget http://prdownloads.sourceforge.net/jack-rack/jack-rack-1.4.7.tar.bz2?download -O jack-rack-1.4.7.tar.bz2
TARBALL=jack-rack-1.4.7.tar.bz2
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  --includedir=/usr/include
sed -i "s@JACK_LIBS = -ljack@JACK_LIBS = -ljack -lpthread -ldl -lm@g" src/Makefile
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "jackrack=>`date`" | sudo tee -a $INSTALLED_LIST
