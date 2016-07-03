#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libfilezilla:0.5.2

cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/project/filezilla/libfilezilla/0.5.2/libfilezilla-0.5.2.tar.bz2
TARBALL="libfilezilla-0.5.2.tar.bz2"
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "libfilezilla=>`date`" | sudo tee -a $INSTALLED_LIST

