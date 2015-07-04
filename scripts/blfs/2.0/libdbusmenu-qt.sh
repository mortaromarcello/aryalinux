#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:qt5


cd $SOURCE_DIR

wget -nc http://www.linuxfromscratch.org/~krejzi/libdbusmenu-qt-0.9.3+14.10.20140619.tar.xz


TARBALL=libdbusmenu-qt-0.9.3+14.10.20140619.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -DUSE_QT5=TRUE              \
      -DWITH_DOC=OFF              \
      .. &&
make

cat > 1434987998801.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998801.sh
sudo ./1434987998801.sh
sudo rm -rf 1434987998801.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libdbusmenu-qt=>`date`" | sudo tee -a $INSTALLED_LIST