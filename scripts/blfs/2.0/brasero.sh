#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst10-plugins-base
#DEP:itstool
#DEP:libcanberra
#DEP:libnotify
#DEP:gobject-introspection
#DEP:libburn
#DEP:libisofs
#DEP:nautilus
#DEP:totem-pl-parser
#DEP:dvd-rw-tools
#DEP:gvfs


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.0.tar.xz


TARBALL=brasero-3.12.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998819.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998819.sh
sudo ./1434987998819.sh
sudo rm -rf 1434987998819.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "brasero=>`date`" | sudo tee -a $INSTALLED_LIST