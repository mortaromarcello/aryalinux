#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:libusb
#DEP:bluez


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/openobex/openobex-1.7.1-Source.tar.gz


TARBALL=openobex-1.7.1-Source.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998763.sh << "ENDOFFILE"
groupadd -g 90 plugdev
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_INSTALL_LIBDIR=lib  \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
make

cat > 1434987998763.sh << "ENDOFFILE"
make install &&
mv -v /usr/share/doc/openobex{,-1.7.1}
ENDOFFILE
chmod a+x 1434987998763.sh
sudo ./1434987998763.sh
sudo rm -rf 1434987998763.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "openobex=>`date`" | sudo tee -a $INSTALLED_LIST