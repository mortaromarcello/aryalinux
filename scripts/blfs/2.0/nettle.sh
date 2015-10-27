#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/nettle/nettle-2.7.1.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/nettle/nettle-2.7.1.tar.gz


TARBALL=nettle-2.7.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

sed -i '/^install-here/ s/install-static//' Makefile

cat > 1434987998748.sh << "ENDOFFILE"
make install &&
chmod -v 755 /usr/lib/libhogweed.so.2.5 /usr/lib/libnettle.so.4.7 &&
install -v -m755 -d /usr/share/doc/nettle-2.7.1 &&
install -v -m644 nettle.html /usr/share/doc/nettle-2.7.1
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nettle=>`date`" | sudo tee -a $INSTALLED_LIST