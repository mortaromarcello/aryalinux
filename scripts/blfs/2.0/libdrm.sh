#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libpciaccess


cd $SOURCE_DIR

wget -nc http://dri.freedesktop.org/libdrm/libdrm-2.4.59.tar.bz2


TARBALL=libdrm-2.4.59.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e "/pthread-stubs/d" -i configure.ac &&
autoreconf -fiv &&
./configure --prefix=/usr --enable-udev &&
make

cat > 1434987998759.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998759.sh
sudo ./1434987998759.sh
sudo rm -rf 1434987998759.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libdrm=>`date`" | sudo tee -a $INSTALLED_LIST