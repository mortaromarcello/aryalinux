#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:gst10-plugins-base


cd $SOURCE_DIR

wget -nc http://nice.freedesktop.org/releases/libnice-0.1.10.tar.gz


TARBALL=libnice-0.1.10.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --without-gstreamer-0.10 &&
make

cat > 1434987998784.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libnice=>`date`" | sudo tee -a $INSTALLED_LIST