#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake


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
sudo rm -rf $DIRECTORY
 
echo "xfce4-whiskermenu-plugin=>`date`" | sudo tee -a $INSTALLED_LIST
