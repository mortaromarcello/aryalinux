#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#REQ:jack2
#REQ:qt4
#REQ:ffmpeg

cd $SOURCE_DIR

URL=https://github.com/MaartenBaert/ssr/archive/master.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
./configure --prefix=/usr --enable-qt       &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "simple-screen-recorder=>`date`" | sudo tee -a $INSTALLED_LIST


