#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libnotify
#DEP:upower
#DEP:xfce4-panel


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfce4-power-manager/1.4/xfce4-power-manager-1.4.2.tar.bz2


TARBALL=xfce4-power-manager-1.4.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make docdir=/usr/share/doc/xfce4-power-manager-1.4.2 \
     imagesdir=/usr/share/doc/xfce4-power-manager-1.4.2/images install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfce4-power-manager=>`date`" | sudo tee -a $INSTALLED_LIST