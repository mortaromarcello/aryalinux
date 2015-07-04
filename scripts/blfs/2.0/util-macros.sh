#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/util/util-macros-1.19.0.tar.bz2


TARBALL=util-macros-1.19.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure $XORG_CONFIG

cat > 1434987998788.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998788.sh
sudo ./1434987998788.sh
sudo rm -rf 1434987998788.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "util-macros=>`date`" | sudo tee -a $INSTALLED_LIST