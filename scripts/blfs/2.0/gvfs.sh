#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus
#DEP:glib2
#DEP:gtk3
#DEP:libsecret
#DEP:libsoup
#DEP:systemd
#DEP:udisks2


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gvfs/1.22/gvfs-1.22.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gvfs/1.22/gvfs-1.22.3.tar.xz


TARBALL=gvfs-1.22.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-gphoto2 &&
make

cat > 1434987998817.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998817.sh
sudo ./1434987998817.sh
sudo rm -rf 1434987998817.sh

cat > 1434987998817.sh << "ENDOFFILE"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFFILE
chmod a+x 1434987998817.sh
sudo ./1434987998817.sh
sudo rm -rf 1434987998817.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gvfs=>`date`" | sudo tee -a $INSTALLED_LIST