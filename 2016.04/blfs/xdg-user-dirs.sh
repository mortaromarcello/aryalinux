#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:xdg-user-dirs:0.15

cd $SOURCE_DIR

URL=http://user-dirs.freedesktop.org/releases/xdg-user-dirs-0.15.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "xdg-user-dirs=>`date`" | sudo tee -a $INSTALLED_LIST


