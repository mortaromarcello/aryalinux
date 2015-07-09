#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libglade
#DEP:libxfce4util


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/libxfcegui4/4.10/libxfcegui4-4.10.0.tar.bz2


TARBALL=libxfcegui4-4.10.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998823.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998823.sh
sudo ./1434987998823.sh
sudo rm -rf 1434987998823.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libxfcegui4=>`date`" | sudo tee -a $INSTALLED_LIST