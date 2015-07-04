#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://people.freedesktop.org/~aplattner/vdpau/libvdpau-0.9.tar.gz


TARBALL=libvdpau-0.9.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libvdpau=>`date`" | sudo tee -a $INSTALLED_LIST