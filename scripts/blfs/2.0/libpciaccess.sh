#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://xorg.freedesktop.org/archive/individual/lib/libpciaccess-0.13.3.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/lib/libpciaccess-0.13.3.tar.bz2


TARBALL=libpciaccess-0.13.3.tar.bz2
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


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libpciaccess=>`date`" | sudo tee -a $INSTALLED_LIST