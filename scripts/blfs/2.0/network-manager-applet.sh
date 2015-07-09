#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:iso-codes
#DEP:libnotify
#DEP:libsecret
#DEP:networkmanager
#DEP:gobject-introspection
#DEP:polkit-gnome


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.0/network-manager-applet-1.0.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.0/network-manager-applet-1.0.0.tar.xz


TARBALL=network-manager-applet-1.0.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --disable-migration \
            --disable-static    &&
make

cat > 1434987998822.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998822.sh
sudo ./1434987998822.sh
sudo rm -rf 1434987998822.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "network-manager-applet=>`date`" | sudo tee -a $INSTALLED_LIST