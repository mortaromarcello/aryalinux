#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kconfig
#DEP:kdoctools
#DEP:kcoreaddons
#DEP:attica
#DEP:kauth
#DEP:kbookmarks
#DEP:kcodecs
#DEP:kcompletion
#DEP:kconfigwidgets
#DEP:kdbusaddons
#DEP:kdewebkit
#DEP:kglobalaccel
#DEP:kguiaddons
#DEP:ki18n
#DEP:kio
#DEP:kitemviews
#DEP:kjobwidgets
#DEP:kplotting
#DEP:kservice
#DEP:ktextwidgets
#DEP:kwidgetsaddons
#DEP:kwindowsystem
#DEP:kxmlgui
#DEP:solid
#DEP:sonnet


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.7/kdesignerplugin-5.7.0.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/frameworks/5.7/kdesignerplugin-5.7.0.tar.xz


TARBALL=kdesignerplugin-5.7.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

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
 
echo "kdesignerplugin=>`date`" | sudo tee -a $INSTALLED_LIST