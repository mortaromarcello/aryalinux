#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/joe-editor/joe-3.7.tar.gz
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/joe-3.7.tar.gz


TARBALL=joe-3.7.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/joe-3.7 &&
make

cat > 1434987998754.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "joe=>`date`" | sudo tee -a $INSTALLED_LIST