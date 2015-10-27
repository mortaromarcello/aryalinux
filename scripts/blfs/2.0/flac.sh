#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz
wget -nc ftp://downloads.xiph.org/pub/xiph/releases/flac/flac-1.3.1.tar.xz


TARBALL=flac-1.3.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-thorough-tests &&
make

cat > 1434987998832.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998832.sh
sudo ./1434987998832.sh
sudo rm -rf 1434987998832.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "flac=>`date`" | sudo tee -a $INSTALLED_LIST