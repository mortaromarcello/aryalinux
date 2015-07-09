#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:colord-gtk
#DEP:itstool
#DEP:lcms2
#DEP:libcanberra
#DEP:libexif
#DEP:appstream-glib
#DEP:exiv2
#DEP:vte


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.14/gnome-color-manager-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.14/gnome-color-manager-3.14.2.tar.xz


TARBALL=gnome-color-manager-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-packagekit &&
make

cat > 1434987998820.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998820.sh
sudo ./1434987998820.sh
sudo rm -rf 1434987998820.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-color-manager=>`date`" | sudo tee -a $INSTALLED_LIST