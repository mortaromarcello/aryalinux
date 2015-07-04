#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib-networking
#DEP:libxml2
#DEP:sqlite
#DEP:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libsoup/2.48/libsoup-2.48.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsoup/2.48/libsoup-2.48.1.tar.xz


TARBALL=libsoup-2.48.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998784.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libsoup=>`date`" | sudo tee -a $INSTALLED_LIST