#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#REQ:qt4

cd $SOURCE_DIR

URL=https://github.com/MaartenBaert/ssr/archive/master.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

#./configure --prefix=/usr &&
PKG_CONFIG_PATH=/opt/qt-4.8.6/lib/pkgconfig ./configure --prefix=/usr --enable-qt       &&

make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "simple-screen-recorder=>`date`" | sudo tee -a $INSTALLED_LIST


