#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://download.videolan.org/videolan/libdvdread/5.0.2/libdvdread-5.0.2.tar.bz2


TARBALL=libdvdread-5.0.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libdvdread-5.0.2 &&
make

cat > 1434987998834.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libdvdread=>`date`" | sudo tee -a $INSTALLED_LIST