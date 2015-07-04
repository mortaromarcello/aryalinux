#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:json-glib
#DEP:libsoup
#DEP:ModemManager


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/geoclue/releases/2.1/geoclue-2.1.10.tar.xz


TARBALL=geoclue-2.1.10.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998784.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "geoclue2=>`date`" | sudo tee -a $INSTALLED_LIST