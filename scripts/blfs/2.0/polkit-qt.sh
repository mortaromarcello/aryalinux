#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:polkit
#DEP:qt5


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2
wget -nc ftp://ftp.kde.org/pub/kde/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2


TARBALL=polkit-qt-1-0.112.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_LIBDIR=lib  \
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
 
echo "polkit-qt=>`date`" | sudo tee -a $INSTALLED_LIST