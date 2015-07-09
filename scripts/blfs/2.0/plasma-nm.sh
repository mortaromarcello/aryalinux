#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kdelibs4support
#DEP:networkmanager-qt
#DEP:plasma-framework


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/plasma/5.2.0/plasma-nm-5.2.0.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/plasma/5.2.0/plasma-nm-5.2.0.tar.xz


TARBALL=plasma-nm-5.2.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DQML_INSTALL_DIR=lib/qt5/qml           \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      .. &&
make

cat > 1434987998811.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998811.sh
sudo ./1434987998811.sh
sudo rm -rf 1434987998811.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "plasma-nm=>`date`" | sudo tee -a $INSTALLED_LIST