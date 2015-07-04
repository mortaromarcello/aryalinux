#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gsettings-desktop-schemas
#DEP:gtk3
#DEP:iso-codes
#DEP:itstool
#DEP:xkeyboard-config
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.14/gnome-desktop-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.14/gnome-desktop-3.14.2.tar.xz


TARBALL=gnome-desktop-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-gnome-distributor="BLFS" &&
make

cat > 1434987998813.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998813.sh
sudo ./1434987998813.sh
sudo rm -rf 1434987998813.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-desktop=>`date`" | sudo tee -a $INSTALLED_LIST