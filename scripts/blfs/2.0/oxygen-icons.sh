#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/applications/14.12.2/src/oxygen-icons-14.12.2.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/applications/14.12.2/src/oxygen-icons-14.12.2.tar.xz


TARBALL=oxygen-icons-14.12.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX ..

cat > 1434987998809.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998809.sh
sudo ./1434987998809.sh
sudo rm -rf 1434987998809.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "oxygen-icons=>`date`" | sudo tee -a $INSTALLED_LIST