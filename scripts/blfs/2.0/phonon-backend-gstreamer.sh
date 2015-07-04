#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst10-plugins-base
#DEP:libxml2
#DEP:phonon


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/phonon/phonon-backend-gstreamer/4.8.2/src/phonon-backend-gstreamer-4.8.2.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/phonon/phonon-backend-gstreamer/4.8.2/src/phonon-backend-gstreamer-4.8.2.tar.xz


TARBALL=phonon-backend-gstreamer-4.8.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr  \
      -DCMAKE_BUILD_TYPE=Release   \
      -DCMAKE_INSTALL_LIBDIR=lib   \
      -DPHONON_BUILD_PHONON4QT5=ON \
      -Wno-dev .. &&
make

cat > 1434987998801.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998801.sh
sudo ./1434987998801.sh
sudo rm -rf 1434987998801.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "phonon-backend-gstreamer=>`date`" | sudo tee -a $INSTALLED_LIST