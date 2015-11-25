#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

KDE_PREFIX=/usr
cd $SOURCE_DIR

URL=http://users.xfce.org/~benny/files/xfce4-dev-tools/4.4/xfce4-dev-tools-4.4.0.tar.bz2
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

echo "xfce4-dev-tools=>`date`" | sudo tee -a $INSTALLED_LIST

