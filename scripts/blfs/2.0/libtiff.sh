#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz
wget -nc ftp://ftp.remotesensing.org/libtiff/tiff-4.0.3.tar.gz


TARBALL=tiff-4.0.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/glDrawPixels/a glFlush();' tools/tiffgt.c &&
./configure --prefix=/usr --disable-static &&
make

cat > 1434987998767.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998767.sh
sudo ./1434987998767.sh
sudo rm -rf 1434987998767.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libtiff=>`date`" | sudo tee -a $INSTALLED_LIST