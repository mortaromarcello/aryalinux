#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libjpeg
#DEP:libpng
#DEP:libtiff


cd $SOURCE_DIR

wget -nc http://downloads.webmproject.org/releases/webp/libwebp-0.4.2.tar.gz


TARBALL=libwebp-0.4.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr           \
            --disable-static        \
            --enable-experimental   \
            --enable-libwebpdecoder \
            --enable-libwebpdemux   \
            --enable-libwebpmux     &&
make

cat > 1434987998767.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libwebp=>`date`" | sudo tee -a $INSTALLED_LIST