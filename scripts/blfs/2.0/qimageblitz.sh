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

wget -nc http://download.kde.org/stable/qimageblitz/qimageblitz-0.0.6.tar.bz2
wget -nc ftp://ftp.kde.org/pub/kde/stable/qimageblitz/qimageblitz-0.0.6.tar.bz2


TARBALL=qimageblitz-0.0.6.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX -Wno-dev .. &&
make

cat > 1434987998798.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998798.sh
sudo ./1434987998798.sh
sudo rm -rf 1434987998798.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "qimageblitz=>`date`" | sudo tee -a $INSTALLED_LIST