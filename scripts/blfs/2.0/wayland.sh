#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libffi


cd $SOURCE_DIR

wget -nc http://wayland.freedesktop.org/releases/wayland-1.7.0.tar.xz


TARBALL=wayland-1.7.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --disable-documentation &&
make

cat > 1434987998764.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998764.sh
sudo ./1434987998764.sh
sudo rm -rf 1434987998764.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "wayland=>`date`" | sudo tee -a $INSTALLED_LIST