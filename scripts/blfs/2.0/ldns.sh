#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl


cd $SOURCE_DIR

wget -nc http://www.nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz


TARBALL=ldns-1.6.17.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --with-drill      &&
make

cat > 1434987998784.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ldns=>`date`" | sudo tee -a $INSTALLED_LIST