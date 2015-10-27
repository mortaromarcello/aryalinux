#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.14/gsettings-desktop-schemas-3.14.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.14/gsettings-desktop-schemas-3.14.1.tar.xz


TARBALL=gsettings-desktop-schemas-3.14.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998812.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998812.sh
sudo ./1434987998812.sh
sudo rm -rf 1434987998812.sh

cat > 1434987998812.sh << "ENDOFFILE"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFFILE
chmod a+x 1434987998812.sh
sudo ./1434987998812.sh
sudo rm -rf 1434987998812.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gsettings-desktop-schemas=>`date`" | sudo tee -a $INSTALLED_LIST