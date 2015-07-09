#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:appstream-glib
#DEP:desktop-file-utils
#DEP:gtk3
#DEP:itstool
#DEP:gobject-introspection
#DEP:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gucharmap/3.14/gucharmap-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gucharmap/3.14/gucharmap-3.14.2.tar.xz


TARBALL=gucharmap-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --enable-vala &&
make

cat > 1434987998822.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998822.sh
sudo ./1434987998822.sh
sudo rm -rf 1434987998822.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gucharmap=>`date`" | sudo tee -a $INSTALLED_LIST