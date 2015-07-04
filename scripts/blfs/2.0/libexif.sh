#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/libexif/libexif-0.6.21.tar.bz2


TARBALL=libexif-0.6.21.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --with-doc-dir=/usr/share/doc/libexif-0.6.21 &&
make

cat > 1434987998766.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libexif=>`date`" | sudo tee -a $INSTALLED_LIST