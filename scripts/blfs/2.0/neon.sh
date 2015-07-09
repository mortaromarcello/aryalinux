#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl
#DEP:gnutls


cd $SOURCE_DIR

wget -nc http://www.webdav.org/neon/neon-0.30.1.tar.gz


TARBALL=neon-0.30.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --enable-shared --with-ssl --disable-static &&
make

cat > 1434987998785.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "neon=>`date`" | sudo tee -a $INSTALLED_LIST