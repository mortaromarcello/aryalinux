#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kemoticons
#DEP:kdesignerplugin
#DEP:kinit
#DEP:kitemmodels
#DEP:kparts
#DEP:kunitconversion


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.7/portingAids/kdelibs4support-5.7.0.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/frameworks/5.7/portingAids/kdelibs4support-5.7.0.tar.xz


TARBALL=kdelibs4support-5.7.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:4.2:4.5:g" cmake/FindDocBookXML4.cmake

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      .. &&
make

cat > 1434987998807.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998807.sh
sudo ./1434987998807.sh
sudo rm -rf 1434987998807.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kdelibs4support=>`date`" | sudo tee -a $INSTALLED_LIST