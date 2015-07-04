#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kdelibs4support
#DEP:alsa-lib


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/applications/14.12.2/src/kmix-14.12.2.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/applications/14.12.2/src/kmix-14.12.2.tar.xz


TARBALL=kmix-14.12.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:\${ECM_MODULE_PATH}:\${CMAKE_SOURCE_DIR}/cmake/modules &:g" CMakeLists.txt

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DKMIX_KF5_BUILD=1                 \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      -Wno-dev .. &&
make

cat > 1434987998812.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998812.sh
sudo ./1434987998812.sh
sudo rm -rf 1434987998812.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kmix=>`date`" | sudo tee -a $INSTALLED_LIST