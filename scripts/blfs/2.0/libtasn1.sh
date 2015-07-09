#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.2.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/libtasn1/libtasn1-4.2.tar.gz


TARBALL=libtasn1-4.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998762.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998762.sh
sudo ./1434987998762.sh
sudo rm -rf 1434987998762.sh

cat > 1434987998762.sh << "ENDOFFILE"
make -C doc/reference install-data-local
ENDOFFILE
chmod a+x 1434987998762.sh
sudo ./1434987998762.sh
sudo rm -rf 1434987998762.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libtasn1=>`date`" | sudo tee -a $INSTALLED_LIST