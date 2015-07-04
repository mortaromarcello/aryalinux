#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:adwaita-icon-theme
#DEP:gtk3
#DEP:itstool
#DEP:gnome-desktop
#DEP:gobject-introspection
#DEP:gsettings-desktop-schemas
#DEP:libsecret
#DEP:nautilus
#DEP:poppler


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/evince/3.14/evince-3.14.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evince/3.14/evince-3.14.1.tar.xz


TARBALL=evince-3.14.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr           \
            --enable-introspection  \
            --disable-static        &&
make

cat > 1434987998819.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998819.sh
sudo ./1434987998819.sh
sudo rm -rf 1434987998819.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "evince=>`date`" | sudo tee -a $INSTALLED_LIST