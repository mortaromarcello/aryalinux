#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.57.tar.xz


TARBALL=iso-codes-3.57.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998769.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "iso-codes=>`date`" | sudo tee -a $INSTALLED_LIST