#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus
#DEP:glib2
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.14/at-spi2-core-2.14.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.14/at-spi2-core-2.14.1.tar.xz


TARBALL=at-spi2-core-2.14.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998792.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998792.sh
sudo ./1434987998792.sh
sudo rm -rf 1434987998792.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "at-spi2-core=>`date`" | sudo tee -a $INSTALLED_LIST