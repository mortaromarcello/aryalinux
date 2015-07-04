#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz


TARBALL=opus-1.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998837.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "opus=>`date`" | sudo tee -a $INSTALLED_LIST