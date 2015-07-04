#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter-gtk
#DEP:geoclue2
#DEP:geocode-glib
#DEP:gjs
#DEP:libchamplain


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.14/gnome-maps-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.14/gnome-maps-3.14.2.tar.xz


TARBALL=gnome-maps-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998821.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998821.sh
sudo ./1434987998821.sh
sudo rm -rf 1434987998821.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-maps=>`date`" | sudo tee -a $INSTALLED_LIST