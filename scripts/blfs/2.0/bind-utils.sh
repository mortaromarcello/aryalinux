#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.isc.org/isc/bind9/9.10.1-P1/bind-9.10.1-P1.tar.gz


TARBALL=bind-9.10.1-P1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make -C lib/dns &&
make -C lib/isc &&
make -C lib/bind9 &&
make -C lib/isccfg &&
make -C lib/lwres &&
make -C bin/dig

cat > 1434987998783.sh << "ENDOFFILE"
make -C bin/dig install
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "bind-utils=>`date`" | sudo tee -a $INSTALLED_LIST