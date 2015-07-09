#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:extra-cmake-modules
#DEP:glib2
#DEP:qt5


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/phonon/4.8.3/src/phonon-4.8.3.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/phonon/4.8.3/src/phonon-4.8.3.tar.xz


TARBALL=phonon-4.8.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:BSD_SOURCE:DEFAULT_SOURCE:g" cmake/FindPhononInternal.cmake

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr  \
      -DCMAKE_BUILD_TYPE=Release   \
      -DCMAKE_INSTALL_LIBDIR=lib   \
      -DPHONON_BUILD_PHONON4QT5=ON \
      -Wno-dev .. &&
make

cat > 1434987998801.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998801.sh
sudo ./1434987998801.sh
sudo rm -rf 1434987998801.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "phonon=>`date`" | sudo tee -a $INSTALLED_LIST