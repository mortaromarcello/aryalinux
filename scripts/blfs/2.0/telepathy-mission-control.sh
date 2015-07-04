#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:telepathy-glib
#DEP:networkmanager


cd $SOURCE_DIR

wget -nc http://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.3.tar.gz


TARBALL=telepathy-mission-control-5.16.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static --disable-upower &&
make

cat > 1434987998816.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998816.sh
sudo ./1434987998816.sh
sudo rm -rf 1434987998816.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "telepathy-mission-control=>`date`" | sudo tee -a $INSTALLED_LIST