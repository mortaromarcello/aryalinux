#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:sqlite
#DEP:telepathy-glib
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.1.tar.bz2


TARBALL=telepathy-logger-0.8.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998816.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998816.sh
sudo ./1434987998816.sh
sudo rm -rf 1434987998816.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "telepathy-logger=>`date`" | sudo tee -a $INSTALLED_LIST