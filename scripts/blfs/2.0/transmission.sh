#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:curl
#DEP:libevent
#DEP:openssl
#DEP:gtk3


cd $SOURCE_DIR

wget -nc https://transmission.cachefly.net/transmission-2.84.tar.xz


TARBALL=transmission-2.84.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998830.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "transmission=>`date`" | sudo tee -a $INSTALLED_LIST