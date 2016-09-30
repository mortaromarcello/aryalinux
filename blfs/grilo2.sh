#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL="http://ftp.gnome.org/pub/gnome/sources/grilo/0.2/grilo-0.2.12.tar.xz"
wget -nc http://ftp.gnome.org/pub/gnome/sources/grilo/0.2/grilo-0.2.12.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --disable-static &&
make

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "grilo2=>`date`" | sudo tee -a $INSTALLED_LIST
