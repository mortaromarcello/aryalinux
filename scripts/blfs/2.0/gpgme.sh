#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libassuan


cd $SOURCE_DIR

wget -nc ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.5.3.tar.bz2


TARBALL=gpgme-1.5.3.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --disable-fd-passing \
            --disable-gpgsm-test &&
make

cat > 1434987998746.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998746.sh
sudo ./1434987998746.sh
sudo rm -rf 1434987998746.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gpgme=>`date`" | sudo tee -a $INSTALLED_LIST