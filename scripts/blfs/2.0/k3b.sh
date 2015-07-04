#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kde-runtime
#DEP:libkcddb
#DEP:libsamplerate
#DEP:ffmpeg
#DEP:libdvdread
#DEP:libjpeg
#DEP:taglib


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/k3b/k3b-2.0.3.tar.xz


TARBALL=k3b-2.0.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DSYSCONF_INSTALL_DIR=/etc         \
      -Wno-dev ..  &&
make

cat > 1434987998839.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "k3b=>`date`" | sudo tee -a $INSTALLED_LIST