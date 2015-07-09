#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kdelibs
#DEP:mariadb
#DEP:taglib
#DEP:ffmpeg


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/amarok/2.8.0/src/amarok-2.8.0.tar.bz2
wget -nc ftp://ftp.kde.org/pub/kde/stable/amarok/2.8.0/src/amarok-2.8.0.tar.bz2


TARBALL=amarok-2.8.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DKDE4_BUILD_TESTS=OFF             \
      -Wno-dev .. &&
make

cat > 1434987998838.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "amarok=>`date`" | sudo tee -a $INSTALLED_LIST