#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:murrine:0.98.2

cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/gtk-murrine-engine/murrine-0.98.2.tar.xz/bf01e0097b5f1e164dbcf807f4b9745e/murrine-0.98.2.tar.xz
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "murrine-gtk-engine=>`date`" | sudo tee -a $INSTALLED_LIST
