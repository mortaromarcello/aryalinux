#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:appstream-glib
#DEP:dconf
#DEP:desktop-file-utils
#DEP:gsettings-desktop-schemas
#DEP:itstool
#DEP:vte
#DEP:gnome-shell
#DEP:nautilus
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-terminal/3.14/gnome-terminal-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-terminal/3.14/gnome-terminal-3.14.2.tar.xz


TARBALL=gnome-terminal-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr       \
            --disable-migration \
            --disable-static &&
make

cat > 1434987998821.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998821.sh
sudo ./1434987998821.sh
sudo rm -rf 1434987998821.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-terminal=>`date`" | sudo tee -a $INSTALLED_LIST