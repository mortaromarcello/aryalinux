#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxcb


cd $SOURCE_DIR

wget -nc http://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2


TARBALL=xcb-util-wm-0.4.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure $XORG_CONFIG &&
make

cat > 1434987998790.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998790.sh
sudo ./1434987998790.sh
sudo rm -rf 1434987998790.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xcb-util-wm=>`date`" | sudo tee -a $INSTALLED_LIST