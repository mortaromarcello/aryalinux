#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.14/gnome-backgrounds-3.14.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.14/gnome-backgrounds-3.14.1.tar.xz


TARBALL=gnome-backgrounds-3.14.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998816.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998816.sh
sudo ./1434987998816.sh
sudo rm -rf 1434987998816.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-backgrounds=>`date`" | sudo tee -a $INSTALLED_LIST