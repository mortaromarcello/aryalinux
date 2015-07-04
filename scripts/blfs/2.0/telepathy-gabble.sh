#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cacerts
#DEP:gnutls
#DEP:openssl
#DEP:sqlite
#DEP:telepathy-glib
#DEP:libnice
#DEP:libsoup


cd $SOURCE_DIR

wget -nc http://telepathy.freedesktop.org/releases/telepathy-gabble/telepathy-gabble-0.18.3.tar.gz


TARBALL=telepathy-gabble-0.18.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/telepathy-gabble-0.18.3 &&
make

cat > 1434987998816.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998816.sh
sudo ./1434987998816.sh
sudo rm -rf 1434987998816.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "telepathy-gabble=>`date`" | sudo tee -a $INSTALLED_LIST