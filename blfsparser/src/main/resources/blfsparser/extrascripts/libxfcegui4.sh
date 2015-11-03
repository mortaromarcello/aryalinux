#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libglade
#REQ:libxfce4util
cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/libxfcegui4/4.10/libxfcegui4-4.10.0.tar.bz2
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libxfcegui4=>`date`" | sudo tee -a $INSTALLED_LIST
