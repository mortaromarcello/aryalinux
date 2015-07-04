#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python3


cd $SOURCE_DIR

wget -nc http://xcb.freedesktop.org/dist/xcb-proto-1.11.tar.bz2


TARBALL=xcb-proto-1.11.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure $XORG_CONFIG

cat > 1434987998789.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998789.sh
sudo ./1434987998789.sh
sudo rm -rf 1434987998789.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xcb-proto=>`date`" | sudo tee -a $INSTALLED_LIST