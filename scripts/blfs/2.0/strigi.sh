#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:dbus
#DEP:qt4


cd $SOURCE_DIR

wget -nc http://www.vandenoever.info/software/strigi/strigi-0.7.8.tar.bz2


TARBALL=strigi-0.7.8.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s/BufferedStream :/STREAMS_EXPORT &/" libstreams/include/strigi/bufferedstream.h &&

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -DCMAKE_BUILD_TYPE=Release  \
      -DENABLE_CLUCENE=OFF        \
      -DENABLE_CLUCENE_NG=OFF     \
      .. &&
make

cat > 1434987998773.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "strigi=>`date`" | sudo tee -a $INSTALLED_LIST