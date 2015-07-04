#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:xkeyboard-config
#DEP:libxcb


cd $SOURCE_DIR

wget -nc http://xkbcommon.org/download/libxkbcommon-0.5.0.tar.xz


TARBALL=libxkbcommon-0.5.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libxkbcommon-0.5.0 &&
make

cat > 1434987998763.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libxkbcommon=>`date`" | sudo tee -a $INSTALLED_LIST