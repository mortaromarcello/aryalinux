#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:mesalib


cd $SOURCE_DIR

wget -nc http://crux.nu/files/libepoxy-1.2.tar.gz


TARBALL=libepoxy-1.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./autogen.sh --prefix=/usr &&
make

cat > 1434987998795.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libepoxy=>`date`" | sudo tee -a $INSTALLED_LIST