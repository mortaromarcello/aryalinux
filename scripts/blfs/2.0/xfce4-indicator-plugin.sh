#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libindicator


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/panel-plugins/xfce4-indicator-plugin/0.3/xfce4-indicator-plugin-0.3.0.0.tar.bz2


TARBALL=xfce4-indicator-plugin-0.3.0.0.tar.bz2
DIRECTORY=xfce4-indicator-plugin-0.3.0.0

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998846.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998846.sh
sudo ./1434987998846.sh
sudo rm -rf 1434987998846.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfce4-indicator-plugin=>`date`" | sudo tee -a $INSTALLED_LIST