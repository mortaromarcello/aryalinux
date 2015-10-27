#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:exo
#DEP:libxfce4ui
#DEP:libnotify
#DEP:startup-notification
#DEP:systemd
#DEP:xfce4-panel


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/thunar/1.6/Thunar-1.6.4.tar.bz2


TARBALL=Thunar-1.6.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/Thunar-1.6.4 &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "thunar=>`date`" | sudo tee -a $INSTALLED_LIST