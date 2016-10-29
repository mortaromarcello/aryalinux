#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="The Whisker Menu presents a Windows-Like start menu for XFCE panel"
NAME="xfce4-whiskermenu-plugin"
VERSION="1.5.0"

#REQ:cmake


cd $SOURCE_DIR

wget -nc http://mirror.netcologne.de/xfce/src/panel-plugins/xfce4-whiskermenu-plugin/1.5/xfce4-whiskermenu-plugin-1.5.0.tar.bz2


TARBALL=xfce4-whiskermenu-plugin-1.5.0.tar.bz2
DIRECTORY=xfce4-whiskermenu-plugin-1.5.0

tar -xf $TARBALL

cd $DIRECTORY

mkdir build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..

make

cat > 1434987998845.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


 
cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
