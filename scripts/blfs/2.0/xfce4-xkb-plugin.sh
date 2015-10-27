#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:librsvg
#DEP:libxklavier
#DEP:xfce4-panel


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/panel-plugins/xfce4-xkb-plugin/0.5/xfce4-xkb-plugin-0.5.6.tar.bz2


TARBALL=xfce4-xkb-plugin-0.5.6.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-debug  \
            --disable-static &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfce4-xkb-plugin=>`date`" | sudo tee -a $INSTALLED_LIST