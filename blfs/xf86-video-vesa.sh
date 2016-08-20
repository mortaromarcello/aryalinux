#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:xf86-video-vesa:2.3.4

#REQ:libevdev
#REQ:xorg-server
#REC:mtdev

URL=https://www.x.org/archive//individual/driver/xf86-video-vesa-2.3.4.tar.bz2

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "xf86-video-vesa=>`date`" | sudo tee -a $INSTALLED_LIST
