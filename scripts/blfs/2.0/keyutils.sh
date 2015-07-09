#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://people.redhat.com/~dhowells/keyutils/keyutils-1.5.9.tar.bz2


TARBALL=keyutils-1.5.9.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make

cat > 1434987998758.sh << "ENDOFFILE"
make NO_ARLIB=1 USRLIBDIR=/usr/lib install
ENDOFFILE
chmod a+x 1434987998758.sh
sudo ./1434987998758.sh
sudo rm -rf 1434987998758.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "keyutils=>`date`" | sudo tee -a $INSTALLED_LIST