#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:xf86-video-mga:1.6.4

#REQ:xorg-server

cd $SOURCE_DIR

URL="http://ftp.kaist.ac.kr/x.org/individual/driver/xf86-video-mga-1.6.4.tar.bz2"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
make
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "xf86-video-mga=>`date`" | sudo tee -a $INSTALLED_LIST
