#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gnome-desktop
#DEP:libnotify
#DEP:libxml2
#DEP:exempi
#DEP:gobject-introspection
#DEP:libexif
#DEP:adwaita-icon-theme
#DEP:gvfs


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/nautilus/3.14/nautilus-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/nautilus/3.14/nautilus-3.14.2.tar.xz


TARBALL=nautilus-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-tracker    \
            --disable-packagekit &&
make

cat > 1434987998817.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998817.sh
sudo ./1434987998817.sh
sudo rm -rf 1434987998817.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nautilus=>`date`" | sudo tee -a $INSTALLED_LIST