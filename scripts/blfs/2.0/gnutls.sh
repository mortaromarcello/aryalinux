#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:nettle
#DEP:cacerts
#DEP:libtasn1


cd $SOURCE_DIR

wget -nc ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-3.3.12.tar.xz


TARBALL=gnutls-3.3.12.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998746.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998746.sh
sudo ./1434987998746.sh
sudo rm -rf 1434987998746.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnutls=>`date`" | sudo tee -a $INSTALLED_LIST