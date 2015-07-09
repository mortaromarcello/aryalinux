#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:qt4


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2
wget -nc ftp://ftp.kde.org/pub/kde/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2


TARBALL=automoc4-0.9.88.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX -Wno-dev .. &&
make

cat > 1434987998797.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998797.sh
sudo ./1434987998797.sh
sudo rm -rf 1434987998797.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "automoc4=>`date`" | sudo tee -a $INSTALLED_LIST