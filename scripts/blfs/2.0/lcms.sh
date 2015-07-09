#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz


TARBALL=lcms-1.19.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998766.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/lcms-1.19 &&
install -v -m644  README.1ST doc/* \
                  /usr/share/doc/lcms-1.19
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lcms=>`date`" | sudo tee -a $INSTALLED_LIST