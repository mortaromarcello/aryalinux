#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gnome-menus

URL="http://archive.ubuntu.com/ubuntu/pool/universe/a/alacarte/alacarte_3.11.91.orig.tar.xz"

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -r $DIRECTORY
echo "alacarte=>`date`" | sudo tee -a $INSTALLED_LIST
