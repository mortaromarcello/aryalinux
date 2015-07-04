#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/lcms/lcms2-2.6.tar.gz


TARBALL=lcms2-2.6.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998766.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lcms2=>`date`" | sudo tee -a $INSTALLED_LIST