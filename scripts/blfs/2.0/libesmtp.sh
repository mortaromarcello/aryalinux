#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/libesmtp-1.0.6.tar.bz2


TARBALL=libesmtp-1.0.6.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998760.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998760.sh
sudo ./1434987998760.sh
sudo rm -rf 1434987998760.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libesmtp=>`date`" | sudo tee -a $INSTALLED_LIST