#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:attica
#DEP:kbookmarks
#DEP:kjobwidgets
#DEP:kwallet
#DEP:solid


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.7/kio-5.7.0.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/frameworks/5.7/kio-5.7.0.tar.xz


TARBALL=kio-5.7.0.tar.xz
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
      -DECM_MKSPECS_INSTALL_DIR=$KF5_PREFIX/share/qt5/mkspecs/modules \
      .. &&
make

cat > 1434987998806.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998806.sh
sudo ./1434987998806.sh
sudo rm -rf 1434987998806.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kio=>`date`" | sudo tee -a $INSTALLED_LIST